#Shippable's CI of multiple apps within a GitHub Repository using a Docker Integration
---

Steps:
  1. Make sure you have an account at [Shippable](app.shippable.com) account.
  2. Fork this repository and enable it in the **Enable Project** option at [Shippable](app.shippable.com).
  3. Click on the project name and go to the project settings
  4. Look out for a section called **Integrations** and then click on the drop down menu under **Hub Integration** and select **Create Integration**.
  5. Create a **Docker Integration** by giving your credentials and save it. The details of this integration have been mentioned in **shippable.yml** file and you will have to edit these with respect to your Docker Integration before you build the project through Shippable.
  6. Once you have edited the **shippable.yml** file, you will be ready to build the project through Shippable.


