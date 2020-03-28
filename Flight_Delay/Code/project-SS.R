
#install.packages('nycflights13')
library(nycflights13)
Al=nycflights13::airlines
Ap=nycflights13::airports
Fl=nycflights13::flights
Pl=nycflights13::planes
Wt=nycflights13::weather

head(Fl)
library(dplyr)
library(magrittr)
Fl %>%
group_by(origin) %>%
summarise(
    count_origin = n(),
    mean_time = mean(dep_delay, na.rm = TRUE),
    sd_time = sd(dep_delay, na.rm = TRUE))

library(ggplot2)
ggplot(Fl, aes(x = origin, y = dep_delay, fill = origin)) +
  geom_boxplot() +
  theme_classic()

anova_one_way <- aov(dep_delay~origin, data = Fl)
summary(anova_one_way)

TukeyHSD(anova_one_way)
#install.packages('ggridges')
library(ggridges)
ggplot(Fl, aes(x = dep_delay, y = origin)) +
  geom_density_ridges(aes(fill = origin)) +
  scale_fill_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))

#only pos delay
Fl_pos = Fl[Fl$dep_delay>0,]
Fl_pos = na.omit(Fl_pos)
Fl_pos %>%
  group_by(origin) %>%
  summarise(
    count_origin = n(),
    mean_time = mean(dep_delay, na.rm = TRUE),
    sd_time = sd(dep_delay, na.rm = TRUE))

library(ggplot2)
ggplot(Fl_pos, aes(x = origin, y = dep_delay, fill = origin)) +
  geom_boxplot() +
  theme_classic()

anova_one_way <- aov(dep_delay~origin, data = Fl_pos)
summary(anova_one_way)

TukeyHSD(anova_one_way)

library(ggridges)

ggplot(Fl_pos, aes(x = dep_delay, y = origin)) +
  geom_density_ridges(aes(fill = origin)) +
  scale_fill_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))+
  facet_wrap(~origin)

# month + origin
# Scatterplot
ggplot(Fl_pos, aes(month))+ 
  geom_bar(aes(fill=origin), width = 0.5) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Histogram on Origin Airport", 
       subtitle="Delay across Month")+
  facet_wrap(~origin)

anova_two_way <- aov(dep_delay~origin + month, data = Fl_pos)
summary(anova_two_way)
# origin + destination
dest = Fl_pos %>%
  group_by(dest,origin) %>%
  summarise(count = n()) %>% arrange(.,count)

library('tidyr')
library(scales)
#dest = tidyr::spread(dest, origin, count)
#dest.long = tidyr::gather(data =dest, key = dest, value = count,-origin)
ggplot(dest, aes(x=origin, y=dest, fill=count)) + geom_tile()


weather = left_join(Fl_pos, Wt, by = c("origin" = "origin", "month" = "month",'day' = 'day','hour'='hour'))
#install.packages('Hmisc')
library(Hmisc)

##
arr_delay_data <- Fl %>%
  select(arr_delay, dep_delay, hour,origin)  

arr_delay_data$hour <- ifelse(arr_delay_data$hour == 2400, 0, 
                              arr_delay_data$hour)
arr_delay <- arr_delay_data %>%
  select(hour, arr_delay, dep_delay,origin) %>%
  group_by(hour,origin) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE) +
              mean(dep_delay, na.rm = TRUE)) %>%
  na.omit()
g <- ggplot(arr_delay, aes(x = as.numeric(hour), y = avg_delay, 
                           title = "Delay - hourly"))
g + geom_point(color = "Black") + geom_smooth() + ylab("Average Delay (mins)") +
  xlab("Hour")+facet_wrap(~origin)

#weather
#install.packages('corrplot')
library(corrplot)
weather$hour <- ifelse(weather$hour == 24, 0, weather$hour)
weather$arr_delay <- ifelse(weather$arr_delay >= 0,
                            weather$arr_delay, 0)
weather$dep_delay <- ifelse(weather$dep_delay >= 0,
                            weather$dep_delay, 0)
weather$total_delay <- weather$arr_delay + weather$dep_delay

cor_data <- select(weather, total_delay, temp, dewp, humid,
                   wind_dir, wind_speed, wind_gust, precip, pressure, visib)
corrplot(cor(na.omit(cor_data)), method = "circle", type = "upper",
         tl.srt = 25, tl.col = "Black", tl.cex = 1, title = "Correlation
         between all 'weather' variables & 'delay'", mar =c(0, 0, 4, 0) + 0.1)