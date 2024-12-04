# networkmerge


<!-- README.md is generated from README.Rmd. Please edit that file -->

Welcome to the networkmerge project.

The code in this repo was developed to support the Network Planning Tool
for Scotland, which can be found at
[www.npt.scot](https://www.npt.scot).

For reproducibility and automation the code in the
[`paper.qmd`](paper.qmd) file is run as part of a GitHub Actions
workflow. The build status is:

[![Quarto
Publish](https://github.com/nptscot/networkmerge/actions/workflows/publish.yml/badge.svg)](https://github.com/nptscot/networkmerge/actions/workflows/publish.yml)

To install the dependencies needed to reproduce the paper, see the code
in the [devcontainer](./.devcontainer) and
[publish.yml](./.github/workflows/publish.yml) file (you can run the
code in this repo in a devcontainer to avoid the installation step).

After the dependencies are installed you can rebuild the paper by
running the following command from the root directory of this repo:

``` bash
quarto render paper.qmd
```

See the rendered result, which automatically updates after each commit
to the main branch, at
[nptscot.github.io/networkmerge](https://nptscot.github.io/networkmerge/).

The methods were presented at [GISRUK
2024](https://zenodo.org/records/11077553).
