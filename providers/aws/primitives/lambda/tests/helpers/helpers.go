package helpers

import (
	"regexp"
	"testing"

	"github.com/stretchr/testify/assert"
)

var lambdaARNRegex = regexp.MustCompile(`^arn:aws[^:]*:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9_-]+$`)

// AssertValidLambdaARN verifies that the given value is a syntactically valid Lambda function ARN.
func AssertValidLambdaARN(t *testing.T, arn string) {
	t.Helper()
	assert.True(t, lambdaARNRegex.MatchString(arn),
		"expected a valid Lambda function ARN but got: %s", arn)
}
