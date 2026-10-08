library(tidyverse)

bilby <- read_csv("data/bilby.csv")

bilby |>
  slice_head(n = 1500) |>
  ggplot(aes(x3, x8)) +
  geom_point(size = 0.5) +
  theme_minimal()


