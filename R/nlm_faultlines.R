# #
# library(sf)
# #
# # l = st_linestring(cbind(1:4,1:4))
# #
# # pt = l %>% st_cast("MULTIPOINT")
# #
# # s = st_split(l, pt)
# #
# #
# # plot(l)
# # plot(pt, add = TRUE, col = "red")
# # plot(s, col = "green",  lty = 1, lwd = 1)
# #
#
#
# polygon <- st_polygon(list(cbind(c(0,0,1,1,0),c(0,1,1,0,0))))
# plot(polygon, add = TRUE)
#
# blade_line <- st_linestring(matrix(c(-0.1, 1.2, 0.2, 0.6),2))
#
# m <- (blade_line[4] - blade_line[3]) / (blade_line[2] - blade_line[1])
#
# plot(blade_line, add = TRUE)
#
# # blade_polygon <- st_polygon(list(cbind(c(0.5,0.5,1.5,1.5,0.5),c(0.5,1.5,1.5,0.5,0.5))))
# # plot(polygon1, add = TRUE)
#
# # s  <-  st_split(polygon, blade_line)
# # s1  <-  st_split(polygon, blade_polygon)
# s2 <- st_sfc(sf:::CPL_split(st_geometry(polygon), st_geometry(blade_line)))
#
# plot(s2, add = TRUE)
#


# library(sf)
#
# pol <- rbind(c(-3,3), c(-3,4), c(-2,4), c(-2,3), c(-3,3))
# pol <- st_polygon(list(pol))
# blade <- rbind(c(-2.5, 3), c(-2.6, 4))
# blade <- st_linestring(blade)
#
# plot(pol)
# plot(blade, add = TRUE)
#
# test <- st_sfc(sf:::CPL_split(st_geometry(pol), st_geometry(blade)))
#
# str(test[1])
# test[1][[1]][1, drop = FALSE]
#
#
# plot(test[1][[1]][[1]])
# plot(test[1][[1]][[2]], add = TRUE, col = "skyblue")
