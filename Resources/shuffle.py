import random

with open("words.txt") as f:
    all_words = f.read().split("\n")
    all_words = [x for x in all_words if x]
    
random.shuffle(all_words)

with open("words_shuffled.txt", "w") as f:
    f.write("\n".join(all_words))
