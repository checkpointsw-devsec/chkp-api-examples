# The Security Management generic object(s) API endpoint

## Disclaimer

These APIs provide direct access to different objects and fields in the database. As a result if an objects schema changes, a scripts that relied on specific schema fields may break.

Since the generic-object(s) API calls have direct access to change different objects and fields in the database, they do not provide any data validation to ensure that the data added to the fields are following required format for the field. Therefore you have to ensure that the script or 3rd party system you are using to integrate with the management server is doing appropriate data validation before sending the API call.

When you have the option, always prefer to use the documented API calls and not the generic API calls as they are

- They are doing data validation
- They are documented
- They are future compatible
- They are tested
- They are supported by Technical Assistance Center (TAC)

