import vertexai
from vertexai.generative_models import GenerativeModel, Part


def analyze_bouquet_image(image_path) -> str:
    
    # --------  Important: Variable declaration  --------

    project_id = "project-id"
    location = "REGION"
    
    
    # Initialize Vertex AI
    vertexai.init(project=project_id, location=location)
    # Load the model
    multimodal_model = GenerativeModel("gemini-1.0-pro-vision")
        
    # Query the model
    response = multimodal_model.generate_content(
        [
            # Add an image
            Part.from_uri(
                'gs://generativeai-downloads/images/scones.jpg', mime_type="image/jpeg"
            ),
            # Add an query
            "generate birthday wishes based on the image",
        ]
    )

    return response.text



#  --------   Call the Function  --------

imagepath="/home/student/image.jpeg"

response = analyze_bouquet_image(imagepath)
print(response)
