#' IDs for running cross validation
#'
#' This function creates a string of integers which will be used for pointing to the right subsets of data for cross validation of regression objects
#'
#' @param data data used in regression model
#' @param folds integer number of validation data sets
#' @param block column in data indicating the blocking structure for cross-validation (if \code{block} = NULL, individual observations will be used as blocks)
#' @param seed integer number used to set the seed of the fold generation.  By default this is set to `1234`.
#'
#' @details The function returns a random sequence of 1:folds of the same length as observations in data. It is called by other functions, e.g. \code{\link{getCV_CReSS}}.
#'
#' @examples
#' # load data
#' data(ns.data.re)
#' 
#' CVids<-getCVids(ns.data.re, 5)
#' 
#' @author LAS Scott-Hayward, University of St Andrews
#' 
#' @export
#' 
#' 
getCVids <- function(data, folds, block=NULL, seed=1234){                        
  if(is.null(block)==T)
  {
    N <- 1:nrow(data)                                       
    n_cv <- ceiling(length(N)/folds)                          
    set.seed(seed)                                          
    id_cv <- sample(rep(1:folds, n_cv), n_cv*folds)         
    id_cv <- id_cv[1:length(N)]   
  }
  else
  {
    if(length(block)==1){
      blocks<-unique(data[,block])
    }else{
      blocks<-unique(block)
    }
    nBlocks<-length(blocks)
    n_cv <- ceiling(nBlocks/folds)
    set.seed(seed)                                          
    id_block_cv <- sample(rep(1:folds,n_cv),n_cv*folds)
    id_block_cv <- id_block_cv[1:length(blocks)]
    id_cv<-numeric(length(block))
    for (xi in 1:nBlocks){
      rows<-which(block==blocks[xi])
      id_cv[rows]<-id_block_cv[xi] 
    }
  }
  return(id_cv)                                           
}                             