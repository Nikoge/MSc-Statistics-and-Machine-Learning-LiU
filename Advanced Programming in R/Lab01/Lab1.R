rm(list=ls())
name <- "Thijs Quast"
liuid <- "thiqu264"

#1.1 Vectors
#1.1.1 my_num_vector()

my_num_vector <- function() {
  x <- c(log10(11), cos(pi/5), exp(pi/3), (1173%% 7)/19)
  return(x)
}

my_num_vector()

# 1.1.2 filter_my_vector(x,leq)

filter_my_vector <- function(x, leq) {
  x <- replace(x, x>=leq, NA) 
  #y <- which(x >= leq)
    return(x)
}

#filter_my_vector = Vectorize(filter_my_vector)
filter_my_vector(x= c(2,9,2,4,102), leq=4)


# 1.1.3 dot.prod(a,b)

dot_prod <- function(a, b) {
 c <- sum(a*b)
  return(c)
}
  
dot.prod(a = c(3,1,12,2,4), b = c(1,2,3,4,5))
dot.prod(a = c(-1, 3), b= c(-3,-1))


# 1.1.4 approx_e(N)

approx_e <- function(N){
  x <- c(1:N)
  y <- 1/factorial(x)
  z <- sum(y)
  a <- z + 1
  return(a)
}


approx_e(N=2)
approx_e(N=4)

#1.2 Matrices

# 1.2.1 my_magic_matrix()
my_magic_matrix <- function(){
  z <- matrix(c(4,9,2,3,5,7,8,1,6), 3)
  x <- t(z)
  return(x)
}

my_magic_matrix()

# 1.2.2 calculate_elements(A)

calculate_elements <- function(A){
  x <- nrow(A)
  y <- ncol(A)
  z <- x*y
  return(z)
}

mat <- my_magic_matrix()
calculate_elements(A=mat)

new_mat <- cbind(mat, mat)
calculate_elements(A=new_mat)

# 1.2.3 row_to_zero(A,i)

row_to_zero <- function(A, i){
  A[i, ] <- 0
  return(A)
}
row_to_zero(A = mat, i = 2)

# 1.2.4 add_elements_to_matrix
add_elements_to_matrix <- function(A, x, i, j){
  A[i,j] = A[i,j]+x
  return(A)
}

add_elements_to_matrix(A=mat, x=10, i=2, j=3)


# 1.3 Lists
# 1.3.1 my_magic_list
my_magic_list <- function(){
  a <- list(info="my own list", c(1.04139, 0.80902, 2.84965, 0.21053), t(matrix(c(4,9,2,3,5,7,8,1,6), 3))) 
  return(a)
}

my_magic_list()

# 1.3.2 change.info(x, text)
a_list <- my_magic_list()

a_list

change_info <- function(x, text){
  x$info <- text
  return(x)
}

a_list
change_info(x = a_list, text= "Some new info")

# 1.3.3 add_note(x, note)
add_note <- function(x, note){
  x$note <- note
  return(x)
}

add_note(x=a_list, note = "This is a magic list!")

# 1.3.4 sum_numeric_parts(x)
sum_numeric_parts <- function(x){
z <- unlist(x)
y <- sum(as.numeric(z), na.rm = TRUE)
return(y)
}

sum_numeric_parts(x = a_list[2])

#1.4 data.frames
# 1.4.1 my_date_frame()
my_data.frame <- function(){
  id <- c(1,2,3)
  name <- c("John", "Lisa", "Azra")
  income <- c(7.30, 0.00, 15.21)
  rich <- c(FALSE, FALSE, TRUE)
  x <- data.frame(id, name, income, rich)
  return(x)
}

my_data.frame()

# sort_head(df, var.name, n) 

sort_head <- function(df, var.name, n){
df <- df[order(-df[var.name]),]
df2 <- df[1:n,]
return(df2)
}

sort_head(df=iris, var.name="Petal.Length", n=5)

# add_median_variable(df, j)

add_median_variable <- function(df, j){
  med <- median(df[,j])
  df$compared_to_median <- med
  df$compared_to_median[df[,j] < df$compared_to_median] <- "Smaller"
  df$compared_to_median[df[,j] > df$compared_to_median] <- "Greater"
  df$compared_to_median[df[,j] == df$compared_to_median] <- "Median"
return(df)
  }

head(add_median_variable(faithful, 1))
tail(add_median_variable(faithful, 2))

# analyze_columns(df, j)

analyze_columns(iris, i=c(1,3))

analyze_columns <- function(df, j){
  a <- j[1]
  b <- j[2]
  d <- df[,a]
  e <- df[,b]
  de <- cbind(d,e)
  colnames(de) <- c(names(df)[j[1]], names(df)[j[2]])
  result1 <- c(mean=mean(d), median=median(d), sd=sd(d))
  result2 <- c(mean=mean(e), median=median(e), sd=sd(e))
  correlation <- cor(de)
  list <- list(result1, result2, correlation)
  names(list) <- c(names(df)[j[1]], names(df)[j[2]], "correlation_matrix")
  return(list)
}

analyze_columns(iris, j=c(1,3))
colnames(iris)

mark_my_assignment()


