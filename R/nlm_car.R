nlm_car <- function (ncol,
                     nrow,
                     rho = 0.2499,
                     row2 = 0,
                     col2 = 0,
                     rc1 = 0,
                     cr1 = 0,
                     maindi = 1,
                     rajz = TRUE)
{
  col1 <- rho
  row1 <- rho
  max_dim <- max(nrow, ncol)
  M <- as.integer(ceiling(base::log(max_dim - 1, 2)))
  NN <- M^2
  FNN <- NN/2
  I1 <- array(rep(0, NN))
  I1[1] <- 1
  NR1 <- array(rep(0, NN))
  NR1[2] <- 1
  NR1[NN] <- 1
  NC1 <- array(rep(0, NN))
  NC1[M + 1] <- 1
  NC1[NN - M + 1] <- 1
  NR2 <- array(rep(0, NN))
  NR2[3] <- 1
  NR2[NN - 1] <- 1
  NC2 <- array(rep(0, NN))
  NC2[2 * M + 1] <- 1
  NC2[NN - 2 * M + 1] <- 1
  NRC1 <- array(rep(0, NN))
  NRC1[M + 2] <- 1
  NRC1[NN - M] <- 1
  NCR1 <- array(rep(0, NN))
  NCR1[M] <- 1
  NCR1[NN - M + 2] <- 1
  k <- maindi * I1 - row1 * NR1 - col1 * NC1 - row2 * NR2 -
    col2 * NC2 - rc1 * NRC1 - cr1 * NCR1
  d2 <- fft(k, inverse = FALSE)
  qse <- sqrt(Re(d2))
  par(mfrow = c(1, 1))
  nkar <- 0
  while (nkar == 0) {
    xe <- rnorm(NN)
    x <- fft(xe)
    for (i in 1:NN) {
      x[i] <- x[i]/qse[i]
    }
    y <- (fft(x, inverse = TRUE))/M
    yre <- Re(y)
    A <- matrix(yre, byrow = TRUE, nrow = M, ncol = M)
    nkar <- 3
  }
  A <- A/sum(A * A)
  if (rajz) {
    par(mfrow = c(1, 1))
    image(A)
  }
  return(A)
}


nlm_car(LEVEL = 6, rho = 0.0499, row2 = 0.4, col2 = 0, rc1 = 0, cr1 = 0,
        maindi = 1, rajz = TRUE)

