Import("env")

# Substitui o comando de upload padrão por um com --no-stub
env.Replace(
    UPLOADERFLAGS=[
        "--chip", "esp32",
        "--port", env["UPLOAD_PORT"],
        "--baud", str(env["UPLOAD_SPEED"]),
        "--before", "default_reset",
        "--after", "hard_reset",
        "--no-stub",  # A mágica
        "write_flash", "-z",
        "--flash_mode", "dio",
        "--flash_freq", "40m",
        "--flash_size", "detect",
        "0x1000", "bootloader.bin",
        "0x8000", "partitions.bin",
        "0xe000", "boot_app0.bin",
        "0x10000", "firmware.bin"
    ]
)
