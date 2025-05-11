/*
 @author: Joey G ii
  */
public with sharing class RestUtil {
  public static Boolean findRecord(RestService service, RestResponse response) {
    if (String.isBlank(service?.getId())) {
      response.statusCode = 200;
      response.responseBody = Blob.valueOf('{}');
      return false;
    } else {
      return true;
    }
  }

  public static void updateResponse(RestResponse response) {
    response.responseBody = Blob.valueOf('No content');
    response.statusCode = 204;
  }
  public static void badDataResponse(RestResponse response) {
    response.responseBody = Blob.valueOf('Incorrect Data');
    response.statusCode = 422;
  }
  public static void okResponse(RestResponse response, RestService service) {
    response.responseBody = service != null
      ? Blob.valueOf(service.get())
      : Blob.valueOf('{}');
    response.statusCode = 200;
  }
  public static void serverSideException(Exception e, RestResponse response) {
    response.statusCode = 500;
    response.responseBody = Blob.valueOf(
      RestStringUtil.SERVER_SIDE_EXCEPTION_MSG + e.getMessage()
    );
    return;
  }

  public static Boolean validateParameters(
    String param,
    RestResponse response,
    RestRequest request
  ) {
    if (String.isBlank(param)) {
      response.statusCode = 422;
      response.responseBody = Blob.valueOf(RestStringUtil.INVALID_PARAMS_MSG);

      return false;
    } else {
      return true;
    }
  }

  public static Boolean validateUriResource(
    String resourceUri,
    RestResponse response,
    RestRequest request
  ) {
    try {
      RestConfig.ControllerResource.valueOf(resourceUri.toUpperCase());
      return true;
    } catch (Exception e) {
      response.statusCode = 422;
      response.responseBody = Blob.valueOf(RestStringUtil.INVALID_ENDPOINT_MSG);

      return false;
    }
  }

  public static List<String> stringToList(String str) {
    List<String> strList = new List<String>();
    if (String.isNotBlank(str)) {
      strList = str.split(';');
    }
    return strList;
  }
  public static Boolean listsHaveMatchingValues(
    List<Object> listOne,
    List<Object> listTwo
  ) {
    Boolean match = false;
    for (Object obj : listOne) {
      if (listTwo.contains(obj)) {
        match = true;
      }
    }

    return match;
  }

  public static Boolean isStringGreaterThanLimit(String s) {
    Boolean overLimit = false;
    if (s?.length() >= 255) {
      overLimit = true;
    }
    return overLimit;
  }

  public static Map<String, Object> toMap(RestService service) {
    return (Map<String, Object>) JSON.deserializeUntyped(
      JSON.serialize(service)
    );
  }
}
