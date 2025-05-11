@RestResource(urlMapping='/joe-gillick/*')
global without sharing class RestController {
  static Map<String, String> params;
  @TestVisible
  static RestRequest request;
  @TestVisible
  static RestResponse response;
  static RestService service;
  static String requestUri;

  @HttpGet
  global static void returnData() {
    try {
      setStaticVariables();
      if (!validateResourceUri()) {
        return;
      }

      if (!validateParameters()) {
        return;
      }
      service = RestConfig.setGetResponse(requestUri, params);
      if (!findRecord()) {
        return;
      }
      RestUtil.okResponse(response, service);
      return;
    } catch (Exception e) {
      RestUtil.serverSideException(e, response);
    }
  }

  @HttpPatch
  global static void patchData() {
    setStaticVariables();
    if (!validateResourceUri()) {
      return;
    }

    String requestBody = request.requestBody.toString();

    System.debug(LoggingLevel.INFO, 'Request Body: ' + requestBody);
    try {
      service = RestConfig.configureDeserialization(requestUri, requestBody);
      System.debug(LoggingLevel.INFO, 'service created: ' + service);
      Boolean recordFound = findRecord();

      if (!recordFound) {
        return;
      }

      service.patch();
      RestUtil.updateResponse(response);

      return;
    } catch (Exception e) {
      RestUtil.serverSideException(e, response);
      return;
    }
  }

  @HttpPut
  global static void putData() {
    //TODO:
    return;
  }

  @HttpPost
  global static void insertData() {
    //TODO:
    return;
  }
  @HttpDelete
  global static void deleteData() {
    //TODO:
    return;
  }
  public static void setStaticVariables() {
    params = new Map<String, String>();
    request = RestContext.request;
    response = RestContext.response;
    response.addHeader('Content-Type', 'application/json');
    requestUri = request.requestURI != null
      ? request.requestURI.substringAfterLast('/')
      : null;

    params.put(
      RestStringUtil.ID_PARAM,
      request.params.get(RestStringUtil.ID_PARAM)
    );
  }
  public static Boolean findRecord() {
    return RestUtil.findRecord(service, response);
  }
  public static Boolean validateResourceUri() {
    return RestUtil.validateUriResource(requestUri, response, request);
  }

  public static Boolean validateParameters() {
    return RestUtil.validateParameters(
      params.get(RestStringUtil.ID_PARAM),
      response,
      request
    );
  }
}
