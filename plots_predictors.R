library(tidyverse)

ds <- read_csv("derived_data/ds_clean.csv") %>%
  mutate(fallstat = factor(fallstat, levels = 0:2, 
                         labels = c("No falls","Single fall","Multiple falls")),
         fallstat1y = factor(fallstat1y, levels = 0:2, 
                             labels = c("No falls","Single fall","Multiple falls")),
         agegr = factor(age, levels = 1:6,
                        labels = c("65-69","70-74","75-79","80-84","85-89","90+")))

# Distribution of fall history by fall status at 1-year follow-up
ggplot(ds, aes(fallstat)) + 
  geom_bar(stat = "count", position = "dodge", aes(fill = fallstat1y), alpha = 0.9) +
  labs(x = "History of falls at baseline", y = "Frequency", color = "Fall status", fill = "Fall status",
       title = "Figure 1. Distribution of fall history by fall status at 1-year follow-up") + 
  scale_fill_brewer(palette = "BuPu") + 
  scale_color_brewer(palette = "BuPu") +
  theme_bw()
ggsave("figures/figure1_fallstat_fallstat1y.png", width = 8, height = 6)


# Distribution of SPPB score by fall status at 1-year follow-up
ggplot(ds, aes(sppb)) + 
  geom_histogram(stat = "count", position = "dodge", aes(fill = fallstat1y), alpha = 0.9) +
  geom_density(aes(y = ..count.., color = fallstat1y), alpha = 1, size = 0.8) +
  labs(x = "SPPB score", y = "Frequency", color = "Fall status", fill = "Fall status",
       title = "Figure 2. Distribution of SPPB by fall status at 1-year follow-up") + 
  scale_x_continuous(limits = c(-0.5, 12.5), breaks = seq(0, 12, 2)) +
  scale_y_continuous(limits = c(0, 650), breaks = seq(0, 600, 200)) +
  scale_fill_brewer(palette = "BuPu") + 
  scale_color_brewer(palette = "BuPu") +
  theme_bw()
ggsave("figures/figure2_sppb_fallstat1y.png", width = 8, height = 6)

# Distribution of age by fall status at 1-year follow-up
ggplot(ds, aes(agegr)) + 
  geom_bar(stat = "count", position = "dodge", aes(fill = fallstat1y), alpha = 0.9) +
  labs(x = "Age group", y = "Frequency", color = "Fall status", fill = "Fall status",
       title = "Figure 3. Distribution of age by fall status at 1-year follow-up") + 
  scale_fill_brewer(palette = "BuPu") + 
  scale_color_brewer(palette = "BuPu") +
  theme_bw()
ggsave("figures/figure3_age_fallstat1y.png", width = 8, height = 6)

