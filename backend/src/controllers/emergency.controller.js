const telegramService = require("../services/telegram.service");

const sendTestMessage = async (req, res) => {
    try {
        const chatId = 7067458434;

        const message = `
🚨 Lifora Test Alert

Backend is connected successfully.

Telegram integration is working.
`;

        const result = await telegramService.sendTelegramMessage(
            chatId,
            message
        );

        res.status(200).json({
            success: true,
            message: "Telegram message sent successfully.",
            telegram: result,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Failed to send Telegram message.",
            error: error.message,
        });
    }
};

module.exports = {
    sendTestMessage,
};