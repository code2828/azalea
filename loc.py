import sys

def main():
    filename = 'azalea.s'
    total_lines = 0
    valid_lines = 0

    try:
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                total_lines += 1
                s = line.strip()
                # 非空，且去掉前后空白后不以分号开头
                if s and not s.startswith(';'):
                    valid_lines += 1
    except FileNotFoundError:
        print(f"错误：找不到文件 {filename}", file=sys.stderr)
        sys.exit(1)

    print(f"总行数: {total_lines}")
    print(f"非空且第一个非空字符不是分号的行数: {valid_lines}")

if __name__ == "__main__":
    main()
