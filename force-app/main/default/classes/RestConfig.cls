@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class RestConfig {
  public enum ControllerResource {
    INFO
  }

  public static RestService service;
  public static RestService setGetResponse(
    String requestUri,
    Map<String, String> params
  ) {
    ControllerResource controllerResource = ControllerResource.valueOf(
      requestUri.toUpperCase()
    );
    System.debug(LoggingLevel.INFO, 'Resource requested was: ' + requestUri);
    switch on controllerResource {
      when INFO {
        service = buildInfoResponse(params.get(RestStringUtil.ID_PARAM));
      }
    }

    return service;
  }

  public static RestService configureDeserialization(
    String requestUri,
    String requestBody
  ) {
    if (String.isBlank(requestBody)) {
      return service;
    }
    RestService service;

    ControllerResource controllerResource = ControllerResource.valueOf(
      requestUri.toUpperCase()
    );
    System.debug(LoggingLevel.INFO, 'Resource requested was: ' + requestUri);
    switch on controllerResource {
      when INFO {
        service = (RestService) JSON.deserialize(
          requestBody,
          RestInfoImpl.class
        );
      }
    }

    return service;
  }

  /**
   * Returns business info by Id
   * @param String Id
   * @return void
   **/
  private static RestService buildInfoResponse(String paramId) {
    List<Account> accounts = [
      SELECT Id, Name, (SELECT Id, Name FROM Opportunities__r)
      FROM Account
      WHERE Id = :paramId
    ];
    if (accounts.isEmpty()) {
      return service;
    }
    return new RestInfoImpl(accounts[0]);
  }
}
