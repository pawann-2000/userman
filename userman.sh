#!/bin/bash

# Prompt for user action (add or delete)
echo "What would you like to do?"
select action in "Add User" "Delete User" "Exit"; do
  case $action in
  "Add User")
    # Add user logic
    name=$(gum input --placeholder "Username")
    pass=$(gum input --password --placeholder "Password")

    sudo useradd "$name" -p $pass -m # Double quotes for proper username handling

    if [[ $? -eq 0 ]]; then
      echo "User $name created successfully."
      echo -e "Current users are: "
      ls /home
    else
      echo "Error: Failed to create user $name."
    fi
    break
    ;;
  "Delete User")
    # Delete user logic
    name=$(gum input --placeholder "Username to delete")

    choice=$(gum choose --height 4 "Do Not Delete Home Directory" "Delete Home Directory [DANGEROUS]")
    if [[ $choice == "Do Not Delete Home Directory" ]]; then
      sudo userdel "$name"
    fi

    if [[ $choice == "Delete Home Directory [DANGEROUS]" ]]; then
      sudo userdel "$name" -f
      sudo rm -rf /home/$name
    fi

    if [[ $? -eq 0 ]]; then
      echo "User $name deleted successfully!"
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
