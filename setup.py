"""Setup veda-analytics-che."""

from setuptools import find_packages, setup

with open("README.md") as f:
    long_description = f.read()

extra_reqs = {
    "dev": ["pre-commit", "python-dotenv"],
    "deploy": [
        "aws-cdk-lib<3.0.0,>=2.15.0",
        "constructs>=10.0.0,<11.0.0",
        "pydantic",
        "python-dotenv"
    ],
    "test": [
    ],
}


setup(
    name="veda-analytics-che",
    version="0.0.1",
    description="",
    long_description=long_description,
    long_description_content_type="text/markdown",
    python_requires=">=3",
    classifiers=[],
    keywords="",
    author="Development Seed",
    author_email="info@developmentseed.org",
    url="https://github.com/NASA-IMPACT/veda-analytics-che",
    license="MIT",
    packages=find_packages(exclude=["ez_setup", "examples", "tests"]),
    package_data={"veda-analytics-che": ["templates/*.html", "templates/*.xml"]},
    include_package_data=True,
    zip_safe=False,
    install_requires=[],
    extras_require=extra_reqs,
)
