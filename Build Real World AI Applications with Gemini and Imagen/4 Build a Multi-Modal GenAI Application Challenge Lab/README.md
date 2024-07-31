bb-ide-genai-004


https://www.cloudskillsboost.google/course_templates/1076/labs/488228



# Challenge scenario
Scenario: You're a developer at an AI-powered boquet design company. Your clients can describe their dream bouquet, and your system generates realistic images for their approval. To further enhance the experience, you're integrating cutting-edge image analysis to provide descriptive summaries of the generated bouquets. Your main application will invoke the relevant methods based on the users' interaction and to facilitate that, you need to finish the below tasks:


Task 1: Develop a Python function named generate_bouquet_image(prompt). This function should invoke the imagegeneration@002 model using the supplied prompt, generate the image, and store it locally. For this challenge, use the prompt: "Create an image containing a bouquet of 2 sunflowers and 3 roses".


Task 2: Develop a second Python function called analyze_bouquet_image(image_path). This function will take the image path as input along with a text prompt to generate birthday wishes based on the image passed and send it to the gemini-pro-vision model. To ensure responses can be obtained as and when they are generated, enable streaming on the prompt requests.


# To run
Update the following in the python scripts
```
    project_id = "project-id"
    location = "REGION"
```

Then run the following commands:-
```
/usr/bin/python3 /home/student/GenerateImage.py
/usr/bin/python3 /home/student/AnalyzeImage.py
```

