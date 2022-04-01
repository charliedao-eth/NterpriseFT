from pathlib import Path

from setuptools import setup, find_packages


here = Path(__file__).parent.resolve()
long_description = (here / "README.md").read_text(encoding="utf-8")

setup(
    name="nterpriseft",
    version="1.0.0",
    description="Analytics of NFT sales, communities, socials and interconnectedness",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/charliedao-eth/NterpriseFT",
    author="Ash Bellett",
    author_email="ash.bellett.ab@gmail.com",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Build Tools",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3 :: Only",
    ],
    keywords="nft, analytics",
    packages=find_packages(),
    python_requires=">=3.10, <4",
    install_requires=[
        "pandas==1.4.1",
        "python-dotenv==0.20.0",
        "requests==2.27.1"
    ]
)
