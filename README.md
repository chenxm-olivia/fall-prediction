
One-Year Fall Prediction in Older Adults
==============================================================================

This repository contains an analysis of one-year fall prediction among older adults who participated in the National Health and Aging Trends Study (NHATS) in 2011 (Round 1) and 2012 (Round 2).

### Getting Data

The Sample Person interview data from Rounds 1-2 of NHATS are saved in the `source_data` folder of this repository for convenience. All data are available for download from the official website (https://www.nhats.org/researcher/nhats).

### Using This Repository

It is recommended to use this repository via Docker, which builds an environment with all the software needed for the project. However, you may be able to consult the Dockerfile to understand what packages and system dependencies are required to run the code. 

One Docker container is provided for this project. To build the Docker container, you need to run:
```
docker build . -t chenxm
```
This will create a docker container. Then, you should be able to start an RStudio server by running:
```
docker run -v $(pwd):/home/rstudio/work -p 8787:8787 -it chenxm
```
You can access the machine and development environment via http://localhost:8787 in a browser, using the username "rstudio" and the temporary password shown in the terminal.

### Setting Up Git LFS

This repository contains large data files. It is recommended to set up Git Large File Storage (LFS) extension to access the data files.

1. Install Git LFS. 

MacOS users can download and install Git LFS via Homebrew:
```
brew install git-lfs
```
Windows users can download the installer from the Git LFS GitHub page (https://git-lfs.com/) and execute it.

2. Initialize Git LFS for your user account by running:
```
git lfs install
```

3. Inside a Git repository, execute the following line to let Git LFS manage the `.sas7bdat` files. 
```
git lfs track "*.sas7bdat"
```

4. Commit the `.gitattributes` file by running:
```
git add .gitattributes
git commit -m "Added LFS support."
```

5. Push changes to GitHub:
```
git push origin main
```

See the Git LFS GitHub page (https://git-lfs.com/) for more details.

### Project Organization

The project is organized using the Makefile. A Makefile provides a textual description of the relationships between artifacts (source data, derived data sets, figures, etc.) and documents what is needed to construct each artifact and how to construct it. It allows for the automatic reproduction of an artifact and its associated dependencies by running the command.

You can use the tool `make` included in the Docker container to build the report of this analysis or any artifact of interest.

First, you need to create relevant directories to save artifacts by invoking Make:
```
make clean
```
The command line `make clean` will remove existing artifacts (if any) and create relevant working directories for the subsequent procedures.

If you are interested in specific artifact, you can build it by running:
```
make derived_data/valid_multifall1y.csv
```

### Product of Analysis

An HTML format report summarizing the details of the method and results of this analysis will be built by invoking:
```
make report.html
```

### Results of Analysis

This analysis identified influential predictors of fall risk in the following year using regularized logistic regression, applying the least absolute shrinkage and selection operator (LASSO) in a random 80% training sample. Model performance was evaluated in the 20% testing sample. 

Build the report to find more details.