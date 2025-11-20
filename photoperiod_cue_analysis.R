# --- Load libraries ---
library(ggplot2)
library(dplyr)

# --- Import your data ---
# Replace "your_file.csv" with the actual filename
df <- read.csv("/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure System Photoperiod.csv")

# --- Convert ticks (5-minute steps) to Day of Year (DoY) ---
# 12 steps per hour × 24 hours = 288 steps per day
df <- df %>%
  mutate(
    doy = 91 + ticks_5_min / 288    # April 1 = Day 91
  )

# --- Base plot: local temperature vs DoY ---
p <- ggplot(df, aes(x = doy, y = local_temp)) +
  geom_line(color = "#1f78b4", size = 1) +
  labs(
    x = "Day of Year (starting April 1)",
    y = "Local Temperature (°C or normalized)",
    title = "Photoperiod-Driven Temperature Variation"
  ) +
  theme_bw(base_size = 14)

# --- Optionally add photoperiod (second y-axis) ---
p <- p +
  geom_line(aes(y = photoperiod * 0.2),  # scale factor for visibility
            color = "#e31a1c", linetype = "dashed", size = 1) +
  scale_y_continuous(
    sec.axis = sec_axis(~ . / 0.2,
                        name = "Photoperiod (hours)")
  )

print(p)

#####
df <- df %>%
  mutate(
    diff_photo = c(NA, diff(photoperiod))
  )

# View any unusually large changes
df %>% filter(abs(diff_photo) > 0.1)

ggplot(df, aes(x = doy, y = diff_photo)) +
  geom_line(color = "darkred") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  labs(
    x = "Day of Year (starting April 1)",
    y = "Δ Photoperiod (hour change per 5-min tick)",
    title = "Rate of Change in Photoperiod"
  ) +
  theme_bw(base_size = 14)

df %>% 
  filter(doy > 118 & doy < 122) %>% 
  select(doy, photoperiod)

df <- read.csv("/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure System Photoperiod.csv")
