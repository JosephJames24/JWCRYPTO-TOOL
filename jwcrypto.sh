#!/bin/sh

# Function to display the main menu
main_menu() {
    echo "Welcome to the Encryption and Decryption Tool"
    echo "Please select an action:"
    echo "1. Encrypt"
    echo "2. Decrypt"
    echo "3. Exit"
}

# Function to select encryption/decryption algorithm
algorithm_menu() {
    echo "Select an algorithm:"
    echo "1. AES (aes-256-cbc)"
    echo "2. DES"
    echo "3. 3DES (des3)"
    echo "4. RC4"
    echo "5. RSA"
    echo "6. Back to main menu"
}

# Function to perform encryption or decryption
perform_action() {
    ACTION=$1
    ALGORITHM=$2
    read -p "Enter the input file: " INPUT_FILE
    read -p "Enter the output file: " OUTPUT_FILE
    read -p "Enter the key file (for symmetric algorithms): " KEY_FILE

    case $ACTION in
        encrypt)
            case $ALGORITHM in
                1) openssl enc -aes-256-cbc -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                2) openssl enc -des -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                3) openssl enc -des3 -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                4) openssl enc -rc4 -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                5) openssl rsautl -encrypt -inkey "$KEY_FILE" -pubin -in "$INPUT_FILE" -out "$OUTPUT_FILE" ;;
                *) echo "Unsupported encryption algorithm." ;;
            esac
            ;;
        decrypt)
            case $ALGORITHM in
                1) openssl enc -d -aes-256-cbc -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                2) openssl enc -d -des -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                3) openssl enc -d -des3 -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                4) openssl enc -d -rc4 -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" ;;
                5) openssl rsautl -decrypt -inkey "$KEY_FILE" -in "$INPUT_FILE" -out "$OUTPUT_FILE" ;;
                *) echo "Unsupported decryption algorithm." ;;
            esac
            ;;
        *) echo "Invalid action." ;;
    esac

    echo "Operation completed successfully."
}

# Main loop
while true; do
    main_menu
    read -p "Choose an option (1-3): " MAIN_OPTION

    case $MAIN_OPTION in
        1) 
            algorithm_menu
            read -p "Choose an algorithm (1-6): " ALGO_OPTION
            perform_action encrypt $ALGO_OPTION
            ;;
        2) 
            algorithm_menu
            read -p "Choose an algorithm (1-6): " ALGO_OPTION
            perform_action decrypt $ALGO_OPTION
            ;;
        3) 
            echo "Exiting the program."
            exit 0
            ;;
        *) 
            echo "Invalid option. Please try again."
            ;;
    esac
done

