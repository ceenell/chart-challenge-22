# Making a pictogram waffle chart using

# Load packages
library(tidyverse)
library(ggwaffle)
library(emojifont)


salt_df <- tibble(params = c('Fresh', 'Slightly saline', 'Moderately saline','Highly saline'),
                  min = c(0, 1000, 3000, 10000),
                  max = c(1000, 3000, 10000, 35000))

## make the waffle
waffle_df <- waffle_iron(salt_df, aes_d(group = max), sample_size = )
waffle_df

ggplot(salt_df, aes(params, max, fill = params)) +
  geom_waffle()


# find the right emoji
emoji(search_emoji('water'))
emoji(search_emoji('rain'))
emoji(search_emoji('drop'))
emoji(search_emoji('food'))

search_emoji('droplet')

