# Dartning barqaror versiyasi asosida boshlaymiz
FROM dart:stable AS build

# Ishchi katalogni tanlang
WORKDIR /app

# Loyihaning barcha fayllarini konteynerga nusxalash
COPY . .

# Paketlarni o'rnatish
RUN dart pub get

# Konteyner uchun "run-time" qatlam
FROM dart:stable AS runtime

# Ishchi katalogni tanlang
WORKDIR /app

# Barcha loyihani runtime qatlami ichiga nusxalash
COPY --from=build /app .

# Botni ishga tushirish uchun asosiy buyruq
CMD ["dart", "run", "bin/namoz_vaqtlari_bot.dart"]
