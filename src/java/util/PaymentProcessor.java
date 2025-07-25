package util;

public class PaymentProcessor {
    public static String processPayment(String cardNumber, String cardExpiry, String cardCvv, double amount) {
        // Validate payment details first
        if (!isValidCardNumber(cardNumber) || !isValidExpiryDate(cardExpiry) || !isValidCvv(cardCvv)) {
            return null;
        }
        
        // In a real implementation, this would call a payment gateway API
        // For testing purposes, we'll simulate a successful payment with a mock transaction ID
        return "txn_" + System.currentTimeMillis();
    }

    public static boolean refundPayment(String transactionId) {
        // Mock implementation - in real app this would call payment gateway's refund API
        return transactionId != null && transactionId.startsWith("txn_");
    }

    public static boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null) return false;
        
        // Remove all whitespace
        String cleanNumber = cardNumber.replaceAll("\\s", "");
        
        // Check length and digits
        if (!cleanNumber.matches("^[0-9]{13,19}$")) {
            return false;
        }
        
        // Luhn algorithm check
        int sum = 0;
        boolean alternate = false;
        for (int i = cleanNumber.length() - 1; i >= 0; i--) {
            int digit = Integer.parseInt(cleanNumber.substring(i, i + 1));
            if (alternate) {
                digit *= 2;
                if (digit > 9) {
                    digit = (digit % 10) + 1;
                }
            }
            sum += digit;
            alternate = !alternate;
        }
        return (sum % 10 == 0);
    }

    public static boolean isValidExpiryDate(String expiry) {
        if (expiry == null) return false;
        
        // Check format MM/YY
        if (!expiry.matches("^(0[1-9]|1[0-2])/?([0-9]{2})$")) {
            return false;
        }
        
        // Check if card is expired
        String[] parts = expiry.split("/");
        int month = Integer.parseInt(parts[0]);
        int year = 2000 + Integer.parseInt(parts[1]);
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentMonth = cal.get(java.util.Calendar.MONTH) + 1; 
        int currentYear = cal.get(java.util.Calendar.YEAR);
        
        return (year > currentYear) || (year == currentYear && month >= currentMonth);
    }

    public static boolean isValidCvv(String cvv) {
        return cvv != null && cvv.matches("^[0-9]{3,4}$");
    }
}