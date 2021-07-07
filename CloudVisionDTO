/**
 * @author      Aaron Dominguez - adominguez@vlocity.com
 * @date        24/05/2019
 * @group       Google Cloud Vision REST API
 * @description A set of DTOs that represents Google Cloud Vision REST API.
 */
public class CloudVisionDTO {
 
    /**
     * @description Set of REST response codes.
     */
    public static final Integer OK = 200;
    public static final Integer BAD_REQUEST = 400;
    public static final Integer UNAUTHORIZED = 401;
    public static final Integer INTERNAL_SERVER_ERROR = 500;
    public static final Integer NOT_FOUND = 404;
    public static final Integer CONFLICT = 409;
 
    /**
     * @description Set of REQUEST FEATURES TYPES request codes.
     */
    public static final String FEATURE_TYPE_TEXT_DETECTION = 'TEXT_DETECTION';
 
    //-- CONSTRUCTORS
    /**
     * @description Enforce non-instantiability.
     */
    private CloudVisionDTO() {
        throw new CloudVisionDTOException('This class cannot be instantiated.');
    }
 
    //-- DESERIALIZE (PARSE) METHODS
    /**
     * @description Parses JSON string into ResponseHandler.
     * @param json the data to parse.
     * @return the parsed data.
     */
    public static ResponseHandler parseAnnotateImageResponse(final String json) {
        return (ResponseHandler) System.JSON.deserialize(json, ResponseHandler.class);
    }
 
    //-- SERIALIZE METHODS (BUILD) METHODS
     /**
     * @description Builds a request serializing a RequestHandler class into a JSON.
     * @param encodedImageSrc the image encoded in base64 to be sent.
     * @return the payload in JSON format.
     */
    public static String buildAnnotateImageRequest(final String encodedImageSrc) {
        RequestHandler rHandler = new RequestHandler();
        rHandler.requests.add(new AnnotateImageRequest(encodedImageSrc));
        return System.JSON.serialize((RequestHandler) rHandler);
    }
 
    //-- REQUEST DTOs
    /**
     * @description Request class.
     */
    public class RequestHandler {
        public List<Object> requests = new List<Object>();
    }
 
    //-- RESPONSE DTOs
    /**
     * @description Response class.
     */
    public class ResponseHandler {
        public List<AnnotateImageResponse> responses = new List<AnnotateImageResponse>();
    }
 
    //-- ENTITY DTOs
    /**
     * @description Class that represents an AnnotateImageRequest.
     */
    public class AnnotateImageRequest {
        public Image image;
        public List<Feature> features;
 
        // Constructor
        public AnnotateImageRequest(String image) {
            this.image = (Image) new Image(image);
            this.features = new List<Feature>{new Feature(FEATURE_TYPE_TEXT_DETECTION)};
        }
    }
    
    /**
     * @description Class that represents an Image.
     */
    public class Image {
        public String content;
 
        // Constructor
        public Image(String image) {
            this.content = image;
        }
    }
 
    /**
     * @description Class that represents a Feature.
     */
    public class Feature {
        public String type;
        public String maxResults;
 
        // Constructor
        public Feature(final String featureType) {
            this.type = featureType;
        }
    }
    
    /**
     * @description Class that represents a AnnotateImageResponse.
     */
    public class AnnotateImageResponse {
        public List<TextAnnotation> textAnnotations;
    }
 
    /**
     * @description Class that represents a TextAnnotation.
     */
    public class TextAnnotation {
        public String locale;
        public String description;
        public BoundingPoly boundingPoly;
    }
 
    /**
     * @description Class that represents a BoundingPoly.
     */
    public class BoundingPoly {
        public List<Vertice> vertices;
        public List<Vertice> normalizedVertices;
    }
 
    /**
     * @description Class that represents a Vertice.
     */
    public class Vertice {
        public Decimal x;
        public Decimal y;
    }
 
    /**
     * @description Class that handles unexpected exceptions
     */
    private class CloudVisionDTOException extends Exception {}
}
