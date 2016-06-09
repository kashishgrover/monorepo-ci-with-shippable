#**Shippable's CI of GitHub Monorepos with DockerHub**

###**Monorepos**
Monorepos, or monolithic repositories, can be defined as follows:

 - The repository contains more than one logical project (e.g. an iOS client and a web-application)
 - These projects are most likely unrelated, loosely connected or can be connected by other means (e.g via dependency management tools)
 - The repository is large in many ways:
	 - Number of commits
	 - Number of branches and/or tags
	 - Number of files tracked
	 - Size of content tracked (as measured by looking at the .git directory of the repository)

For more information regarding monorepos, click [here](https://developer.atlassian.com/blog/2015/10/monorepos-in-git/).

**Consider the following monorepo scenario as an example:**

![enter image description here](https://raw.githubusercontent.com/kashishgrover/monorepo-ci-with-shippable/master/Project%20Flowchart.png)





###**The Challenge**
Each monorepo will have a shippable.yml file, and each App inside the monorepo will have its own Dockerfile. The challenge here is to make sure that if a change is made in a file within App 1, then Shippable should build, commit and push the repository on DockerHub with respect to App 1 only. 
Using Environment Variables provided by Shippable, we can write a simple bash script to achieve this goal.

A bash script which I wrote can be found on this GitHub repository. The following steps will guide you on how to use it. 
  1. Make sure you have an account at [app.shippable.com](https://app.shippable.com/).
  2. Fork this repository and enable it in the **Enable Project** option at [Shippable](app.shippable.com).
  3. Click on the project name and go to the project settings
  4. Look out for a section called **Integrations** and then click on the drop down menu under **Hub Integration** and select **Create Integration**.
  5. Create a **Docker Integration** by giving your credentials and save it. The details of this integration have been mentioned in **shippable.yml** file and you will have to edit these with respect to your Docker Integration before you build the project through Shippable. Click [here](http://docs.shippable.com/ci_configure/) to get a detailed description of this yml file.
  6. Once you have edited the **shippable.yml** file, you will be ready to build the project through Shippable.
  7. The script which runs the Docker build commands here is **build.sh**. You can change the script according to your convenience.
