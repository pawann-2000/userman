#!/bin/bash

# Prompt for user action (add or delete)
echo "What would you like to do?"
select action in "Add User" "Delete User" "Exit"; do
  case $action in
    "Add User")
      # Add user logic
      echo "Enter username:"
      read name

      sudo useradd "$name"  # Double quotes for proper username handling

      if [[ $? -eq 0 ]]; then
        echo "User $name created successfully."
        echo -e 'Enter the password for $name (you will be prompted twice):'
        sudo passwd "$name"
      else
        echo "Error: Failed to create user $name."
      fi
      break
      ;;
    "Delete User")
      # Delete user logic
      echo "Enter the user you want to delete:"
      read delUser

      if [[ -d "/home/$delUser" ]]; then  # Check if user's home directory exists
        sudo userdel -r "$delUser"

        if [[ $? -eq 0 ]]; then
          echo "User $delUser deleted successfully."
        else
          echo "Error: Failed to delete user $delUser."
        fi
      else
        echo "Error: User directory /home/$delUser not found."
      fi
      break
      ;;
    "Exit")
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac
done

# Display current users only if the script hasn't exited
if [[ $? -eq 0 ]]; then
  echo -e "Current users are: "
  ls /home
fi
