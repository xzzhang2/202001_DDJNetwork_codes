## This R file is for the network analysis based on the "co-retweeted" network (Finn et al., 2014), constructed in the Python Notebook in step 4. 

library(foreign)
library(dplyr)
library(readr)
library(psy)
library(psych)

# importing the edge list: xxx_EL.csv 
library(igraph)
ddj_el <- read.csv(file.choose(), encoding = 'utf-8', header = FALSE) 
ddj_el <- na.omit(ddj_el)
head(ddj_el)
dim(ddj_el) 
# convert to igraph objects 
ddj_el_igraphobj <- graph.data.frame(ddj_el, directed = FALSE) 
ddj_el_igraphobj

## network cleaning: keeping the *largest** connected component* 
no.clusters(ddj_el_igraphobj, mode=c("weak", "strong")) 
ddj_el_igraphobj_comp <- components(ddj_el_igraphobj, mode = c("weak", "strong")) 
summary(ddj_el_igraphobj_comp) 
dgtemp <- decompose.graph(ddj_el_igraphobj)
ddj_el_igraphobj_comp1 <- dgtemp[[1]] 
ddj_el_igraphobj_comp1 
# Removing multiple edges 
ddj_el_igraphobj_comp1_simp <- simplify(ddj_el_igraphobj_comp1, remove.multiple = TRUE, remove.loops = TRUE) 
ddj_el_igraphobj_comp1_simp 

# display the network-level statistics (for the network object: "ddj_el_igraphobj_comp1_simp")
edge_density(ddj_el_igraphobj_comp1_simp, loops = FALSE)
transitivity(ddj_el_igraphobj_comp1_simp, type=c("global"), isolates=c("NaN")) 
mean(degree(ddj_el_igraphobj_comp1_simp)) 
mean_distance(ddj_el_igraphobj_comp1_simp, directed = TRUE, unconnected = TRUE) 
diameter(ddj_el_igraphobj_comp1_simp, directed = TRUE, unconnected = TRUE) 

# display the node-level centrality statistics (for the network object: "ddj_el_igraphobj_comp1_simp")
degree_ddj_el_igraphobj_comp1_simp<- degree(ddj_el_igraphobj_comp1_simp, mode = "all", loops = FALSE, normalized = FALSE) 
bet_ddj_el_igraphobj_comp1_simp <- betweenness(ddj_el_igraphobj_comp1_simp, normalized = FALSE) 
clo_ddj_el_igraphobj_comp1_simp <- closeness(ddj_el_igraphobj_comp1_simp, vids=V(ddj_el_igraphobj_comp1_simp),  normalized = FALSE) 
trans_ddj_el_igraphobj_comp1_simp <- transitivity(ddj_el_igraphobj_comp1_simp, type=("local"), weights=NULL, vids=NULL, isolates=("zero"))
describe(cbind(degree_ddj_el_igraphobj_comp1_simp, bet_ddj_el_igraphobj_comp1_simp, clo_ddj_el_igraphobj_comp1_simp, trans_ddj_el_igraphobj_comp1_simp))  
cor.test(degree_ddj_el_igraphobj_comp1_simp, bet_ddj_el_igraphobj_comp1_simp) 

# compiling the results for formatted an output (optional)
ddj_el_igraphobj_comp1_simp_nodestats <- cbind(degree_ddj_el_igraphobj_comp1_simp, bet_ddj_el_igraphobj_comp1_simp,  clo_ddj_el_igraphobj_comp1_simp, trans_ddj_el_igraphobj_comp1_simp) 
options(digits=4)
stat.desc(ddj_el_igraphobj_comp1_simp_nodestats)
write.csv(as.data.frame(stat.desc(ddj_el_igraphobj_comp1_simp_nodestats)), file="outputxxxxx.csv", fileEncoding = "UTF-8") 
write.csv(as.data.frame(ddj_el_igraphobj_comp1_simp_nodestats), file="outputxxxxxx.csv") 

## ERGM codes and results ---- 
# preparing the network for ERGM: converting the igraph object to a Statnet "network object" (via a matrix)
library(igraph) 
ddj_matrix_comp1_simp <- get.adjacency(ddj_el_igraphobj_comp1_simp) 
ddj_matrix_comp1_simp <- as.matrix(ddj_matrix_comp1_simp)
detach("package:igraph", unload=TRUE)
library(statnet)
library(network)
library(coda)
library(RCurl)

# constructin the "network object"
ddj_network4ergm_comp1  <- network(ddj_matrix_comp1_simp, matrix.type = "adjacency", directed = FALSE) 
ddj_network4ergm_comp1 

# export the node names (Twitter account name for manual coding)
ddjnames <- ddj_network4ergm_comp1 %v% "vertex.names"
head(ddjnames)
write.csv(ddjnames, file="ddjnames_all_for_att.csv")

# The manually coded csv file is "ddjnames_att_order.csv".
ddjnames_att_order <- read.csv(file.choose(), header=TRUE)  
ddjnames_att_order$Removal <- as.character(ddjnames_att_order$Removal)
ddjnames_att_order$Gender <- as.character(ddjnames_att_order$gender_v6)
ddjnames_att_order$Country <- as.character(ddjnames_att_order$country_v6) 
ddjnames_att_order$Organization <- as.character(ddjnames_att_order$type_v6)
ddjnames_att_order$tweetcounts <- as.numeric(ddjnames_att_order$tweetcounts)
ddjnames_att_order$following <- as.numeric(ddjnames_att_order$following)
ddjnames_att_order$followers <- as.numeric(ddjnames_att_order$followers)
ddjnames_att_order$Community <- as.numeric(ddjnames_att_order$Community)

set.vertex.attribute(ddj_network4ergm_comp1, "Removal", (ddjnames_att_order$Removal) )
set.vertex.attribute(ddj_network4ergm_comp1, "Gender", (ddjnames_att_order$Gender)) 
set.vertex.attribute(ddj_network4ergm_comp1, "Country_6", (ddjnames_att_order$Country))
set.vertex.attribute(ddj_network4ergm_comp1, "Organization_6", (ddjnames_att_order$Organization)) 
set.vertex.attribute(ddj_network4ergm_comp1, "Community", (ddjnames_att_order$Community)) # the community code is produced by Gephi. 
set.vertex.attribute(ddj_network4ergm_comp1, "followers", (ddjnames_att_order$followers))   
set.vertex.attribute(ddj_network4ergm_comp1, "following", (ddjnames_att_order$following))  
set.vertex.attribute(ddj_network4ergm_comp1, "tweetcounts", (ddjnames_att_order$tweetcounts))  
set.vertex.attribute(ddj_network4ergm_comp1, "followers_log", (log(ddjnames_att_order$followers)+1))  
set.vertex.attribute(ddj_network4ergm_comp1, "following_log", (log(ddjnames_att_order$following)+1))  
set.vertex.attribute(ddj_network4ergm_comp1, "tweetcounts_log", (log(ddjnames_att_order$tweetcounts)+1)) 
list.vertex.attributes(ddj_network4ergm_comp1) 

ddj_network4ergm_comp1_valid <- get.inducedSubgraph(ddj_network4ergm_comp1, which( 
  (ddj_network4ergm_comp1 %v% "Removal" == "0") & 
    (ddj_network4ergm_comp1 %v% "Gender" != "99") & 
    (ddj_network4ergm_comp1 %v% "followers_log" != "NA") & 
    (ddj_network4ergm_comp1 %v% "following_log" != "NA") & 
    (ddj_network4ergm_comp1 %v% "tweetcounts_log" != "NA") & 
    (ddj_network4ergm_comp1 %v% "Country_6" != "99") & 
    (ddj_network4ergm_comp1 %v% "Organization_6" != "98") & 
    (ddj_network4ergm_comp1 %v% "Organization_6" != "99")) ) 
ddj_network4ergm_comp1_valid 

# Descriptive statistics Table 1
# categorical
prop.table(table(ddj_network4ergm_comp1_valid  %v%  "Gender"))
prop.table(table(ddj_network4ergm_comp1_valid  %v%  "Country_6"))
prop.table(table(ddj_network4ergm_comp1_valid  %v%  "Organization_6"))
# continuous  
rbind(describe(ddj_network4ergm_comp1_valid %v%  "followers"), describe(ddj_network4ergm_comp1_valid %v%  "following"), describe(ddj_network4ergm_comp1_valid %v%  "tweetcounts") ) 

# ERGM----
summary(ddj_network4ergm_comp1_valid ~ edges + triangles) 
# nodefactor 
cort_p100_fit1 <- ergm(
  ddj_network4ergm_comp1_valid ~ edges + 
    nodefactor("Gender", levels = c(1,2)) + 
    nodefactor("Country_6", levels = c(1,2,3,4,5,6,7,8) ) + 
    nodefactor("Organization_6", levels = c(1,2,3)) + 
    nodecov("followers_log") +  
    nodecov("following_log") +  
    nodecov("tweetcounts_log"), 
  verbose = FALSE, 
  control = control.ergm(
    force.main = TRUE, 
    MCMLE.maxit = 20,  
    MCMLE.trustregion = 20,
    MCMC.interval= 1024 * 4, 
    MCMC.burnin= 1024 * 4, 
    MCMC.samplesize = 1024 * 32, 
    MCMLE.conv.min.pval = 0.05
  )
) 
summary(cort_p100_fit1)  
mcmc.diagnostics(cort_p100_fit1) 

# nodematch
cort_p100_fit2 <- ergm(
  ddj_network4ergm_comp1_valid ~ edges +
    nodematch("Gender", diff = TRUE) + 
    nodematch("Country_6", diff = TRUE) +  
    nodematch("Organization_6", diff = TRUE) + 
    nodecov("followers_log") + 
    nodecov("following_log") + 
    nodecov("tweetcounts_log"), 
  verbose = FALSE, 
  control = control.ergm(
    force.main = TRUE, 
    MCMLE.maxit = 20,  
    MCMLE.trustregion = 20,
    MCMC.interval= 1024 * 4, 
    MCMC.burnin= 1024 * 4, 
    MCMC.samplesize = 1024 * 32, 
    MCMLE.conv.min.pval = 0.05
  )
) 
summary(cort_p100_fit2) 
mcmc.diagnostics(cort_p100_fit2) 


# - the end of ERGM modeling - 


