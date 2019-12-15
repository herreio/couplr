cat("init share\n")

rds_root <- ""

if(""!=Sys.getenv(c("COUPLR_RDS"))) {
  rds_root <- Sys.getenv(c("COUPLR_RDS"))    
} else {
  rds_root <- system.file("model",package="couplr")
}

cat(paste("rds root:", rds_root, "\n"))
cat(paste("work dir:", getwd(),"\n"))

lda_fps <- list.files(
  rds_root,
  pattern="lda_",
  full.names=T
)

lda_ids <- gsub("_[0-9]+-[0-9]+-[0-9]+","",
  topmodelr::name_from_path(lda_fps)
)

lda_fps <- setNames(lda_fps, lda_ids)

x <- 1
lda_model <- setNames(x, "x")

tts <- function(path, query, w=5, t=3) {
  cat("search topic\n")
  cat(paste0(path,"\n"))
  cat(paste0(query,"\n"))
  prepro <- topmodelr::corpus_prep(tm::VCorpus(tm::VectorSource(query)))
  query <- prepro[[1]]$content
  lda_name <- make.names(topmodelr::name_from_path(path))
  if(lda_name != names(lda_model)) {
    cat("reading model from disk...\n")
    cat(paste("lda_name:", lda_name, "\n"))
    cat(paste("model_name:", names(lda_model), "\n"))
    lda_model <<- topmodelr::read_models(path[1])
    cat("finished reading model from disk!\n")
  }
  res <- topmodelr::lda_search(lda_model[[1]], query, n=w, t=t+1)
  topic_no <- colnames(res)[1:t]
  paste0(sapply(topic_no, function(x) {c(toupper(x),res[,x],"\n")}),"\n")
}
