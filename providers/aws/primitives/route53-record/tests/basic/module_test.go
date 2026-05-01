package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/route53"
	r53types "github.com/aws/aws-sdk-go-v2/service/route53/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestRoute53RecordBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	zoneID := terraform.Output(t, ctx.Terraform, "zone_id")
	zoneName := terraform.Output(t, ctx.Terraform, "zone_name")
	aFqdn := terraform.Output(t, ctx.Terraform, "record_a_fqdn")
	cnameFqdn := terraform.Output(t, ctx.Terraform, "record_cname_fqdn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	r53 := route53.NewFromConfig(cfg)

	t.Run("OutputsPopulated", func(t *testing.T) {
		assert.NotEmpty(t, zoneID)
		assert.True(t, strings.HasSuffix(zoneName, ".internal"))
		assert.True(t, strings.HasPrefix(aFqdn, "api."))
		assert.True(t, strings.HasPrefix(cnameFqdn, "alias."))
	})

	t.Run("ARecordExists", func(t *testing.T) {
		out, err := r53.ListResourceRecordSets(t.Context(), &route53.ListResourceRecordSetsInput{
			HostedZoneId:    aws.String(zoneID),
			StartRecordName: aws.String("api." + zoneName),
			StartRecordType: r53types.RRTypeA,
			MaxItems:        aws.Int32(1),
		})
		require.NoError(t, err, "ListResourceRecordSets A")
		require.GreaterOrEqual(t, len(out.ResourceRecordSets), 1)
		rs := out.ResourceRecordSets[0]
		assert.Equal(t, r53types.RRTypeA, rs.Type)
		assert.Equal(t, int64(60), aws.ToInt64(rs.TTL))
		require.Len(t, rs.ResourceRecords, 2, "A record should have two values")
		values := []string{aws.ToString(rs.ResourceRecords[0].Value), aws.ToString(rs.ResourceRecords[1].Value)}
		assert.Contains(t, values, "10.99.1.10")
		assert.Contains(t, values, "10.99.1.11")
	})

	t.Run("CNAMERecordExists", func(t *testing.T) {
		out, err := r53.ListResourceRecordSets(t.Context(), &route53.ListResourceRecordSetsInput{
			HostedZoneId:    aws.String(zoneID),
			StartRecordName: aws.String("alias." + zoneName),
			StartRecordType: r53types.RRTypeCname,
			MaxItems:        aws.Int32(1),
		})
		require.NoError(t, err, "ListResourceRecordSets CNAME")
		require.GreaterOrEqual(t, len(out.ResourceRecordSets), 1)
		rs := out.ResourceRecordSets[0]
		assert.Equal(t, r53types.RRTypeCname, rs.Type)
		require.Len(t, rs.ResourceRecords, 1)
		assert.Equal(t, "api."+zoneName, aws.ToString(rs.ResourceRecords[0].Value))
	})
}
