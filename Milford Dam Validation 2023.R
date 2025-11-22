library(ggplot2)

df <- read.csv(
  "D:/NetLogo Models/Penobscot_Mercury_Exposure/outputs/Penobscot_Mercury_Exposure Milford Fish Lift Validation.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)

df$DoY       <- as.numeric(df$DoY)
df$Milford   <- as.numeric(df$Milford)
df$Dam_enter <- as.numeric(df$Dam_enter)

# Scale line to match bar height
scale_factor <- max(df$Milford, na.rm = TRUE) /
  max(df$Dam_enter, na.rm = TRUE)


ggplot(df, aes(x = DoY)) +
  
  # Bars for Milford
  geom_col(aes(y = Milford, fill = "Milford Lift"), alpha = 0.7) +
  
  # Line for Dam Enter
  geom_line(aes(y = Dam_enter * scale_factor, color = "Dam Entry (Simulated)"),
            linewidth = 1.1) +
  
  scale_fill_manual(
    name = "Legend",
    values = c("Milford Lift" = "steelblue")
  ) +
  
  scale_color_manual(
    name = "Legend",
    values = c("Dam Entry (Simulated)" = "red")
  ) +
  
  scale_y_continuous(
    name = "Milford Lift Count",
    sec.axis = sec_axis(~ . / scale_factor,
                        name = "Dam Entry (Simulated)")
  ) +
  
  theme_minimal() +
  ggtitle("Milford Lift (Bars) vs Dam Entry (Simulated Line)") +
  
  # Combine color & fill legends into one
  guides(
    fill  = guide_legend(order = 1),
    color = guide_legend(order = 2)
  )