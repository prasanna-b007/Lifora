const axios = require("axios");
const { botToken } = require("../config/telegram.config");

const sendTelegramMessage = async (chatId, message) => {
    try {
        const url = `https://api.telegram.org/bot${botToken}/sendMessage`;

        const response = await axios.post(url, {
            chat_id: chatId,
            text: message,
        });

        return response.data;
    } catch (error) {
        console.error("Telegram Error:", error.response?.data || error.message);
        throw error;
    }
};

module.exports = {
    sendTelegramMessage,
};