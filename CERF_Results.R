# Load packages
library(tidyverse)
library(lubridate)

# Read in your data
# If it's saved as a CSV, for example "behavior_data.csv":
df <- read_csv("D:/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure Behaviors_11_09_25.csv")

# Create a datetime column (April 1, 2023 + 5-minute intervals)
df <- df %>%
  mutate(
    datetime = as_datetime("2023-04-01 00:00:00") + minutes(5 * ticks_5_min)
  )

# Reshape data to long format for plotting
df_long <- df %>%
  pivot_longer(
    cols = c(STST, Foraging, Filter_Feeding, Lipid_Loss, Home_Patch, Landward, Seaward),
    names_to = "Behavior",
    values_to = "Value"
  )

# Rename behaviors for readability
df_long <- df_long %>%
  mutate(
    Behavior = recode(Behavior,
                      "STST" = "Selective Tidal Stream Transport",
                      "Foraging" = "Foraging",
                      "Filter_Feeding" = "Filter Feeding",
                      "Lipid_Loss" = "Lipid Loss",
                      "Home_Patch" = "Home Patch",
                      "Landward" = "Landward Migration",
                      "Seaward" = "Seaward Migration"
    )
  )

# Define professional color palette
behavior_colors <- c(
  "Selective Tidal Stream Transport" = "#E377C2",
  "Foraging" = "#D4A017",
  "Filter Feeding" = "#2CA02C",
  "Lipid Loss" = "#1F77B4",
  "Home Patch" = "black",
  "Landward Migration" = "#17BECF",
  "Seaward Migration" = "#9467BD"
)

# Professional plot
ggplot(df_long, aes(x = datetime, y = Value, color = Behavior)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = behavior_colors) +
  labs(
    title = "Behavioral Dynamics of River Herring 2023 (Penobscot River, ME)",
    x = "Date",
    y = "Behavioral State (0 = Inactive, 1 = Active)",
    color = "Behavior"
  ) +
  scale_x_datetime(
    date_breaks = "14 days",
    date_labels = "%b %d"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 11),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray85"),
    panel.grid.major.y = element_line(color = "gray90")
  )

# Save the last plot
ggsave(
  filename = "Behavioral_Dynamics_Fish.png",   # output file name
  plot = last_plot(),                           # saves your most recent ggplot
  width = 10, height = 6,                      # size in inches
  dpi = 400,                                   # high resolution
  bg = "white"                                 # ensure white background
)

df <- read_csv("D:/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure Duration of Exposure to Harmful Contamination Levels_11_09_25.csv")

# Create datetime column (5-min intervals starting April 1, 2023)
df <- df %>%
  mutate(
    datetime = as_datetime("2023-04-01 00:00:00") + minutes(5 * x)
  )

df <- df %>%
  mutate(hours = methylmercury * 5 / 60)

# Professional plot
ggplot(df, aes(x = datetime, y = hours)) +
  geom_line(linewidth = 1.2, color = "#9467BD") +
  #geom_point(size = 2, color = "#9467BD") +
  labs(
    title = "Duration of Exposure to Methylmercury Levels above 15 ng/g",
    x = "Date",
    y = "Duration Exposed (hours)"
  ) +
  scale_x_datetime(
    date_breaks = "14 days",
    date_labels = "%b %d"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12),
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray85"),
    panel.grid.major.y = element_line(color = "gray90")
  )

# Save high-resolution image
ggsave(
  filename = "Methylmercury_Timeline.png",
  plot = last_plot(),
  width = 10, height = 6,
  dpi = 400,
  bg = "white"
)

# ----------------------------
# 1. Load Milford Dam fish lift data
# ----------------------------
fish <- read.csv("D:/NetLogo Models/Penobscot_Mercury_Exposure/inputs/Milford_Fish_Lift_2023.csv", header = FALSE)

# Assign column names
colnames(fish) <- c("year", "date", "month", "day", "day_of_year", "fish_count", "other")

# Parse month/day/year format correctly
fish <- fish %>%
  mutate(
    date = mdy(date)   # "4/24/2023" → 2023-04-24
  )

# Check
head(fish)
# ----------------------------
# 2. Load behavioral output data
# ----------------------------
df <- read_csv("D:/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure Behaviors_11_09_25.csv")

# Add datetime column (April 1, 2023 start, 5-min ticks)
df <- df %>%
  mutate(
    datetime = as_datetime("2023-04-01 00:00:00") + minutes(5 * ticks_5_min),
    day = as_date(datetime)
  )

# Convert 5-min ticks to days (if you want a numeric variable too)
df <- df %>%
  mutate(days_since_start = ticks_5_min * 5 / 60 / 24)

# ----------------------------
# 3. Aggregate Home Patch by day
# ----------------------------
home_patch_daily <- df %>%
  group_by(day) %>%
  summarise(mean_home_patch = mean(Home_Patch, na.rm = TRUE))

# ----------------------------
# 4. Merge datasets by day
# ----------------------------
merged <- fish %>%
  rename(fish_date = date) %>%
  inner_join(home_patch_daily, by = c("fish_date" = "day"))

# ----------------------------
# 5. Plot
# ----------------------------
ggplot(merged, aes(x = fish_date)) +
  geom_col(aes(y = fish_count / max(fish_count)), fill = "gray60", alpha = 0.6) +  # normalized bars
  #geom_line(aes(y = mean_home_patch, color = "Home Patch Activity"), linewidth = 1.3) +
  #scale_color_manual(values = c("Home Patch Activity" = "#2CA02C")) +
  scale_y_continuous(
    name = "Home Patch Activity (0–1)",
    sec.axis = sec_axis(~ . * max(merged$fish_count), name = "Fish Lift Count")
  ) +
  labs(
    title = "Milford Dam Fish Lift Counts 2023",
    x = "Date",
    color = ""
  ) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

# ----------------------------
# 6. Save the plot
# ----------------------------
ggsave(
  filename = "Milford_vs_HomePatch.png",
  plot = last_plot(),
  width = 10, height = 6,
  dpi = 400,
  bg = "white"
)

# ----------------------------
# 1. Load and clean data
# ----------------------------
fish <- read.csv("D:/NetLogo Models/Penobscot_Mercury_Exposure/inputs/Milford_Fish_Lift_2023.csv", header = FALSE)

colnames(fish) <- c("year", "date", "month", "day", "day_of_year", "fish_count", "other")

# Convert date to proper format (month/day/year → 2023-04-24)
fish <- fish %>%
  mutate(date = mdy(date))

# ----------------------------
# 2. Plot Milford fish lift counts
# ----------------------------
ggplot(fish, aes(x = date, y = fish_count)) +
  geom_col(fill = "#4C72B0", alpha = 0.8) +
  labs(
    title = "Milford Dam Fish Lift Counts (2023)",
    x = "Date",
    y = "Fish Lift Count"
  ) +
  scale_x_date(date_breaks = "7 days", date_labels = "%b %d") +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray85"),
    panel.grid.major.y = element_line(color = "gray90")
  )

# ----------------------------
# 3. Save high-resolution image
# ----------------------------
ggsave(
  filename = "Milford_Fish_Lift_2023.png",
  plot = last_plot(),
  width = 10, height = 6,
  dpi = 400,
  bg = "white"
)