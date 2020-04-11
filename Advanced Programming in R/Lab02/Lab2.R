# Lab 2 ####
rm(list=ls())
name <- "Thijs Quast"
liuid <- "thiqu264"


# 1.1 Conditional statements ####
# 1.1.1 Sheldon game ####
sheldon_game <- function(player1, player2){
  if(player1 %in% c("rock", "paper", "scissors", "lizard", "spock") & player2 %in% c("rock", "paper", "scissors", "lizard", "spock"))  {
  choices <- matrix(data = NA, nrow = 25, ncol=3, byrow= TRUE)
  choices <- as.data.frame(choices)
  colnames(choices) <- c("one", "two", "result")
  choices[, 1] <- c(rep("rock", 5), rep("paper", 5), rep("scissors", 5), rep("lizard", 5), rep("spock",5))
  choices[, 2] <- c(rep(c("rock", "paper", "scissors", "lizard", "spock"), 5))
  choices[c(3,4,6,10,12,14,17,20,21,23), 3] <- "Player 1 wins!"
  choices[c(1,7,13,19,25), 3] <- "Draw!"
  choices[c(2,5,8,9,11,15,16,18,22,24), 3] <- "Player 2 wins!"
  outcome <- choices[choices[, "one"]==player1 & choices[, "two"]==player2, "result"]
  return(outcome)
  }
  else {
    stop("input is not correct")
  }
  }

sheldon_game("rock", "rock")

# 1.2 For loops ####
#1.2.1 my_moving_median ####
my_moving_median <- function(x, n, ...){
  if(is.vector(x)==TRUE & is.numeric(n)==TRUE) {
  from <- x[1]
  e <- length(x)
  c <- 1
  d <- e-n
  y <- c()
  for (i in c:d){
  z <- x[i:(i+n)]
  a <- median(z, ...)
  y[i] <- a
  }
  return(y)
  }
  else {stop("Input is incorrect")}
}

my_moving_median(x = 1:10, n=2, na.rm = FALSE)

# 1.2.2 for_mult_table() ####
for_mult_table <- function(from, to){
  if(is.numeric(from)==TRUE & is.numeric(to)==TRUE){
  i <- 1
  dimensionx <- (to-from) + 1
  matrix <- matrix(data = NA, nrow = dimensionx, ncol = dimensionx, byrow = TRUE)
  matrix2 <- matrix(data = NA, nrow = dimensionx, ncol=dimensionx, byrow = FALSE)
  for (x in from:to){
    matrix[,i] <- x
    matrix2[i,] <- x
    i <- i+1
    matrix3 = matrix * matrix2
  }
  colnames(matrix3) <- c(from:to)
  rownames(matrix3) <- c(from:to)
  return(matrix3)
  }
  else {stop("input is incorrect")}
  }

for_mult_table(10,12)


# 1.3 While loops ####
# 1.3.1 find_cumsum() ####
find_cumsum <- function(x, find_sum){
  if(is.numeric(x)==TRUE & is.numeric(find_sum)==TRUE){
  z <- x
  target <- find_sum
  i <- 1
  y <- 1
  a <- length(z)
  b <- sum(z[1:a])
  while(i < a & y <= target){
    i <- i + 1
    y <- sum(z[1:i])
    }
 return(y)
  }
 else{stop("input is incorrect")}
}


find_cumsum(1:10, 1000)

# 1.3.2 while_mult_table ####
while_mult_table <- function(from, to){
  if(is.numeric(from)==TRUE & is.numeric(to)==TRUE){
  i <- 1
  x <- from
  dimensionx <- (to-from) + 1
  matrix <- matrix(data=NA, nrow = dimensionx, ncol = dimensionx)
  matrix2 <- matrix(data=NA, nrow=dimensionx, ncol=dimensionx)
while (x >= from & x<= to){
  matrix[,i] <- x
  matrix2[i,] <- x
  i <- i+1
  x <- x+1
  matrix3 <- matrix * matrix2
}
  colnames(matrix3) <- c(from:to)
  rownames(matrix3) <- c(from:to)
  return(matrix3)
  }
  else {stop("input is incorrect")}
}

while_mult_table(from=4, to=10)

# 1.4 repeat and loop controls ####
# 1.4.1 repeat_find_cumsum()
repeat_find_cumsum <- function(x, find_sum){
  if(is.numeric(x)==TRUE & is.numeric(find_sum)==TRUE){
  z <- x
  target <- find_sum
  i <- 1
  y <- 1
  a <- length(z)
  b <- sum(z[1:a])
  repeat {
    i <- i + 1
    y <- sum(z[1:i])
    if (y > target) 
      break
    else if (i == a & y < target)
      break
  }
  return(as.numeric(y))
  }
  else{stop("input is incorrect")}
}
repeat_find_cumsum(1:10, 1000)

# 1.4.2 repeat_my_moving_median() ####

repeat_my_moving_median <- function(x, n, ...){
  if(is.vector(x)==TRUE & is.numeric(n)==TRUE){
    from <- x[1]
    e <- length(x)
    c <- 1
    i <- 1
    d <- e-n
    y <- c()
    repeat {
      z <- x[i:(i+n)]
      a <- median(z, ...)
      y[i] <- a
      i <- i+1
      if (i == d+1){
        break
      }
    }
    return(y)
  }
  else {stop("Input is incorrect")}
}

repeat_my_moving_median(5:15, n=4, na.rm = TRUE)

# 1.5 Environment ####
# 1.5.1 in_environment ####
in_environment <- function(env){
env <- rm()
env <- search()[length(search())]
return(ls(env))
}
funs <- in_environment(env)
funs[1:5]

# 1.6 Functionals ####
# 1.6.1 cov() ####
cov <- function(X){
  if(is.data.frame(X)==TRUE){
  test = unlist(lapply(X, FUN = function(X) {sd(X) / mean(X)}))
 return(test)
  }
  else {stop("input is incorrect")}
}

cov(X = iris[1:4])
cov(X = iris[3:4])

# 1.7 Closures
# 1.7.1 moment() ####
moment <- function(i){
  if(is.numeric(i)==TRUE){
  return(function(X){
    y <- median(X)
    i <- i
    z <- X - y
    w <- z^i
    u <- length(X)
    v <- w/u
    outcome <- sum(v)
    return(outcome)
  })
  }
else{stop("input is incorrect")}
  }

m1 <-moment(i=1)
m2 <- moment(i=2)
m1(1:100)
m2(1:100)
mark_my_assignment()
