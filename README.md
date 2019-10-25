# Run [`mafft`](https://mafft.cbrc.jp/alignment/software/) through `outsider` in R
[![Build Status](https://travis-ci.org/DomBennett/om..mafft.svg?branch=master)](https://travis-ci.org/DomBennett/om..mafft)

```r
library(outsider)
module_install(repo = 'dombennett/om..mafft')
mafft <- module_import(fname = 'mafft', repo = 'dombennett/om..mafft')
mafft('-h')
```
