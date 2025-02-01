
# BSRPChat

## Overview

**BSRPChat** is a custom chat system designed for the BSRP Free Roam server. It enhances the in-game communication experience by providing features such as:

- **Custom Chat Channels**: Organize conversations into different channels (e.g., General, Admin, Local).
- **Roleplay Enhancements**: Support for roleplay actions and messages.
- **User Permissions**: Control who can access specific channels or features.
- **Chat Formatting**: Rich text formatting options for messages.

## Features

- **Multiple Chat Channels**: Create and manage various chat channels to suit different needs.
- **Roleplay Commands**: Implement commands like `/me` `/say`   `/post` `/posta` `/pol`  `/amb` `/mechad`  `/towad`    for roleplay actions.
- **Permissions System**: Define who can access and use specific chat features.
- **Message Formatting**: Support for bold, italics, and other text styles.
- **Customizable Settings**: Easily adjust settings to fit your server's requirements.

## Installation

1. **Download the Repository**: Clone or download the `bsrpchat` repository to your server's `resources` directory.

   ```bash
   git clone https://github.com/BSRPFreeRoam/bsrpchat.git
   ```

2. **Add to Server Configuration**: Ensure the resource is started by adding it to your `server.cfg`:

   ```plaintext
   ensure bsrpchat
   ```

3. **Configure Settings**: Modify the configuration files within the `bsrpchat` resource to customize channels, permissions, and other settings as needed.

## Usage

- **Accessing Chat Channels**: Use the designated keys or commands to switch between chat channels.
- **Sending Messages**: Type your message and press Enter to send it to the active channel.
- **Roleplay Actions**: Use commands like `/me [action]`   `/say [action]`   `/post [action]` `/posta [action]` `/pol [action]`  `/amb [action]` `/mechad [action]`  `/towad [action]`  to perform roleplay actions visible to nearby players.

## Configuration

The `bsrpchat` resource includes configuration files located in the `config` folder. Here, you can:

- **Define Chat Channels**: Set up different channels with specific names and colors.
- **Set Permissions**: Assign user groups to channels to control access.
- **Customize Formatting**: Adjust text styles and other formatting options.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes.
4. Push to your fork.
5. Open a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/BSRPFreeRoam/bsrpchat/blob/main/LICENSE) file for details.

