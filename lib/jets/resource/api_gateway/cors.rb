module Jets::Resource::ApiGateway
  # Might be weird inheriting from Method because Method has Method#cors also
  # but Cors is essentially a Method class.
  class Cors < Method
    def definition
      {
        cors_logical_id => {
          type: "AWS::ApiGateway::Method",

          properties: {
            resource_id: "!Ref #{resource_id}",
            rest_api_id: "!Ref #{RestApi.logical_id}",
            authorization_type: cors_authorization_type,
            http_method: "OPTIONS",
            method_responses: [{
              status_code: '200',
              response_parameters: {
                "method.response.header.Access-Control-Allow-Origin": true,
                "method.response.header.Access-Control-Allow-Headers": true,
                "method.response.header.Access-Control-Allow-Methods": true,
                "method.response.header.Access-Control-Allow-Credentials": true,
              },
              response_models: {},
            }],
            request_parameters: {},
            integration: {
              type: "MOCK",
              request_templates: {
                "application/json": "{statusCode:200}",
              },
              integration_responses: [{
                status_code: '200',
                response_parameters: {
                  "method.response.header.Access-Control-Allow-Origin": "'#{allow_origin}'",
                  "method.response.header.Access-Control-Allow-Headers": "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
                  "method.response.header.Access-Control-Allow-Methods": "'OPTIONS,GET'",
                  "method.response.header.Access-Control-Allow-Credentials": "'false'",
                },
                response_templates: {
                  "application/json": '',
                },
              }] # closes integration_responses
            } # closes integration
          } # closes properties
        } # closes logical id
      } # closes definition
    end

    def cors_authorization_type
      Jets.config.api.cors_authorization_type || @route.authorization_type || "NONE"
    end

    def cors_logical_id
      "#{resource_logical_id}_cors_api_method"
    end

    def allow_origin
      if Jets.config.cors == true
        '*'
      elsif Jets.config.cors
        Jets.config.cors
      end
    end
  end
end
