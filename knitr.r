##install.packages("knitr")
prepare.my.docs <- function()
    {
        library(knitr)
        filename <- "storm_data_analysis"
        rmd.fn <- paste0(filename,".rmd")
        html.fn <- paste0(filename,".html")
        knit2html(rmd.fn)               # .md is prepared
        browseURL(html.fn)              # html is prepared
        ##install.packages("rmarkdown")
        library(rmarkdown)
        render(rmd.fn, "pdf_document")
    }

prepare.my.docs()
