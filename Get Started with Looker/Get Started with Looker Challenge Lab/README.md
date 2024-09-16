# Get Started with Looker: Challenge Lab


# Task 1. Create a new report in Looker Studio
Create a new Looker Studio report named Online Sales, and connect to Public datasets > qwiklabs-gcp-01-503b4ab9325c > thelook_ecommerce > orders.

Add a time series chart using any theme and title of your choice.


# Task 2. Create a new view in Looker
Create a new view named users_region with the following specifications:

Use the source table named cloud-training-demos.looker_ecomm.users.

Include the following dimensions:

- id as a primary key using the number type and the following sql reference: ${TABLE}.id
- state using the string type and the following sql reference: ${TABLE}.state
- country using the string type and the following sql reference: ${TABLE}.country

Include the following measure:
- count with drill_fields that includes only the dimensions that you have included in the new view

Join the new view to the existing Events Explore.

Deploy your changes to production.



# Task 3. Create a new dashboard in Looker
Use your new view named users_region to create a bar chart of the top 3 event types based on the highest number of users.

Customize your bar chart using any colors and labels of your choice.

Save your bar chart to a new dashboard named User Events.