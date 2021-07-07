/**
 * @author      Aaron Dominguez - adominguez@vlocity.com
 * @date        27/05/2019
 * @group       Google Cloud Vision REST API
 * @description Service class which contains all necessary methods to interact with Google Cloud Vision REST API.
 */
public class CloudVisionService {
 
    //-- ENUM
    /**
     * @description Enumerates all valid REST methods.
     */
    public enum RestMethod {
        GET,
        POST,
        PUT
    }
 
    //-- CONSTANTS
    /**
     * @description The initial URL to connect to Google Cloud API.
     */
    private static final String VISION_ENDPOINT = 'https://vision.googleapis.com/v1/';
 
    //-- ATTRIBUTES
    /**
     * @description The image (ContentVersion) file queried.
     */
    public final ContentVersion image;
 
    //-- CONSTRUCTOR
    /**
     * @description This is the only constructor for this class. You must pass an ContentVersion Id so the system can
     * retreive the associated image to be sent.
     * @param contentVersionId the Id of the ContentVersion to use.
     */
    public CloudVisionService(final Id contentVersionId) {
 
        //Get ContentVersion
        final List<ContentVersion> contentVersionList = [
            select Id, FileExtension, VersionData
            from ContentVersion
            where Id = :contentVersionId
        ];
 
        //If query returned no elements
        if (contentVersionList == null || contentVersionList.isEmpty()) {
            throw new CloudVisionServiceException('Image not found');
        }
 
        //Get the Image to be sent
        else 
            this.image = contentVersionList[0];
    }
 
    //-- SERVICE METHODS
    /**
     * @description Used to get the information retrived from an Image.
     * @return The analysis of the image given by Google Vision Service.
     */
    public CloudVisionDTO.ResponseHandler getImageInformation() {
        //1. Prepare data
        final Map<String,String> params = new Map<String,String>();
        //params.put('', '');
 
        //2. Build request
        final HttpRequest request = this.getRestRequest(
            RestMethod.POST,
            'images:annotate',
            params,
            CloudVisionDTO.buildAnnotateImageRequest(EncodingUtil.base64Encode(this.image.VersionData))
        );
 
        //3. Do callout
        final String responseBody = this.sendRequest(request);
 
        //4. Parse and return response
        return CloudVisionDTO.parseAnnotateImageResponse(responseBody);
    }
 
    //-- PRIVATE METHODS
    /**
     * @description Builds a request based on a resource, rest method, params and request body.
     * @param restMethod the rest method to use to perform the callout.
     * @param resource the resource to call.
     * @param params the query parameters to append to the url - optional.
     * @param body the request body - optional.
     * @return the request, ready to be sent.
     */
    private HttpRequest getRestRequest(final RestMethod restMethod, final String resource, final Map<String, String> params, final String body) {
        //1. Build endpoint
        String endpoint = VISION_ENDPOINT + resource + '?key=' + 'YOUR_KEY_GOES_HERE';
 
        //Check params
        if (params != null && !params.isEmpty()) {
            for (String paramKey : params.keySet()) {
                endpoint += (
                    '&' + paramKey + '=' + EncodingUtil.urlEncode(
                        String.isEmpty(params.get(paramKey)) ? '' : params.get(paramKey), 'UTF-8'
                    )
                );
            }
        }
 
        //2. Build request
        final HttpRequest request = new HttpRequest();
        request.setMethod(restMethod.name());
        request.setTimeout(60000);
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type','application/json; charset=utf-8');
        if (!String.isBlank(body)) request.setBody(body);
 
        //3. Return request
        return request;
    }
 
    /**
     * @description Generic method to send any request. It returns the response as a String.
     * @param request the request to send.
     * @return The response in string format.
     */
    private String sendRequest(final HttpRequest request) {
        final Http http = new Http();
        try {
            //Send request
            final HTTPResponse response = http.send(request);
 
            //-- Check result
            //Response is null
            if (response == null) throw new CloudVisionServiceException('response is null.');
            
            //Response seems NO VALID
            else if (response.getStatusCode() != CloudVisionDTO.OK) {
                throw new CloudVisionServiceException(
                    'Something went wrong. Status: ' + response.getStatus() +
                    ' | Code: ' + response.getStatusCode() +
                    ' | Body: ' + response.getBody()
                );
            }
 
            //Valid response
            else {
                return response.getBody();
            }
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            throw new CloudVisionServiceException(e);
        }
    }
 
    /**
     * @description Class that handles unexpected exceptions
     */
    private class CloudVisionServiceException extends Exception {}
}
