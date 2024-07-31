import argparse

import vertexai
from vertexai.preview.vision_models import ImageGenerationModel

def generate_bouquet_image(prompt: str) -> vertexai.preview.vision_models.ImageGenerationResponse:

    # --------  Important: Variable declaration  --------

    project_id = "project-id"
    location = "REGION"
    
    output_file='image.jpeg'

    vertexai.init(project=project_id, location=location)

    model = ImageGenerationModel.from_pretrained("imagegeneration@002")

    images = model.generate_images(
        prompt=prompt,
        # Optional parameters
        number_of_images=1,
        seed=1,
        add_watermark=False,
    )

    images[0].save(location=output_file)

    return images

generate_bouquet_image(prompt='Create an image containing a bouquet of 2 sunflowers and 3 roses')

