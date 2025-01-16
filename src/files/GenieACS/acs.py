import telebot
from telebot import types
from Token import TELEGRAM_TOKEN
from acs import gantissid, gantipw, gantissidpw

print("Bot Jalan...")
bot = telebot.TeleBot(TELEGRAM_TOKEN)

# Dictionary for storing user state
sufyan_state = {}

# Handle /start command
@bot.message_handler(commands=['start'])
def send_welcome(message):
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True, one_time_keyboard=True)
    markup.add(types.KeyboardButton("Ubah SSID nama WiFi"))
    markup.add(types.KeyboardButton("Ubah Password WiFi"))
    markup.add(types.KeyboardButton("Ubah Pw dan SSID"))
    markup.add(types.KeyboardButton("Cek status perangkat"))
    markup.add(types.KeyboardButton("Complain"))
    bot.reply_to(message, "Selamat datang di Bot sufsembret! Silakan pilih menu:", reply_markup=markup)

# Handle menu selections
@bot.message_handler(func=lambda message: message.text in ["Ubah SSID nama WiFi", "Ubah Password WiFi", "Ubah Pw dan SSID", "Cek status perangkat", "Complain"])
def handle_menu_selection(message):
    chat_id = message.chat.id
    print(message.text)
    
    if message.text == "Ubah SSID nama WiFi":
        step_key = "sn_ssid"
    elif message.text == "Ubah Password WiFi":
        step_key = "sn_pw"
    elif message.text == "Ubah Pw dan SSID":
        step_key = "sn_pw_ssid"
    else:
        return

    sufyan_state[chat_id] = {"step": step_key}
    print(sufyan_state)
    bot.reply_to(message, "Masukkan serial number")

# Handle serial number input for SSID change
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "sn_ssid")
def handle_serial_number_ssid(message):
    chat_id = message.chat.id
    sn = message.text.strip()
    
    sufyan_state[chat_id] = {"step": "isi_ssid", "sn": sn}
    print(sufyan_state)
    bot.reply_to(message, "Masukkan SSID baru")

# Handle SSID input
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "isi_ssid")
def handle_ssid(message):
    chat_id = message.chat.id
    ssid = message.text.strip()
    
    data = sufyan_state[chat_id]
    result = gantissid(data, ssid)
    
    print(result)
    bot.reply_to(message, f"SSID berhasil diubah menjadi {ssid}")
    sufyan_state.pop(chat_id)  # Reset state after completion

# Handle serial number input for password change
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "sn_pw")
def handle_serial_number_pw(message):
    chat_id = message.chat.id
    sn = message.text.strip()
    
    sufyan_state[chat_id] = {"step": "isi_pw", "sn": sn}
    print(sufyan_state)
    bot.reply_to(message, "Masukkan password baru")

# Handle password input
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "isi_pw")
def handle_password(message):
    chat_id = message.chat.id
    pw = message.text.strip()
    
    if len(pw) < 8:
        bot.reply_to(message, "Password minimal 8 karakter, mohon masukkan ulang password")
    else:
        data = sufyan_state[chat_id]
        result = gantipw(data, pw)
        print(result)
        
        bot.reply_to(message, f"Password berhasil diubah menjadi {pw}")
        sufyan_state.pop(chat_id)  # Reset state after completion

# Handle serial number input for SSID and password change
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "sn_pw_ssid")
def handle_serial_number_pw_ssid(message):
    chat_id = message.chat.id
    sn = message.text.strip()
    
    sufyan_state[chat_id] = {"step": "isi_ssid_pw", "sn": sn}
    print(sufyan_state)
    bot.reply_to(message, "Masukkan SSID baru")

# Handle SSID input for SSID and password change
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "isi_ssid_pw")
def handle_ssid_pw(message):
    chat_id = message.chat.id
    ssid = message.text.strip()
    
    sufyan_state[chat_id]["ssid"] = ssid
    sufyan_state[chat_id]["step"] = "isi_pw_ssid"
    print(sufyan_state)
    bot.reply_to(message, "Masukkan password baru")

# Handle password input for SSID and password change
@bot.message_handler(func=lambda message: sufyan_state.get(message.chat.id, {}).get("step") == "isi_pw_ssid")
def handle_pw_ssid(message):
    chat_id = message.chat.id
    pw = message.text.strip()
    
    if len(pw) < 8:
        bot.reply_to(message, "Password minimal 8 karakter, mohon masukkan ulang password")
    else:
        data = sufyan_state[chat_id]
        ssid = data["ssid"]
        result = gantissidpw(data, ssid, pw)
        print(result)

        bot.reply_to(message, f"SSID berhasil diubah menjadi {ssid} dan password berhasil diubah menjadi {pw}")
        sufyan_state.pop(chat_id)  # Reset state after completion

bot.polling(none_stop=True)
