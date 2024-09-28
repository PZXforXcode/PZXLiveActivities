import re
import os

def extract_keys_from_strings_file(file_path):
    with open(file_path, 'r', encoding='latin-1') as file:
        content = file.read()
        matches = re.findall(r'"(.*?)"\s*=\s*".*?";', content)
        return matches

def main():
    # 使用当前脚本所在的目录作为起始点
    script_directory = os.path.dirname(os.path.abspath(__file__))

    # 存储所有的 key，使用 set 来自动去重
    all_keys = set()

    # 遍历当前目录及其子目录下的所有 Localizable.strings 文件
    for root, dirs, files in os.walk(script_directory):
        for file in files:
            if file == 'Localizable.strings':
                file_path = os.path.join(root, file)
                keys = extract_keys_from_strings_file(file_path)
                if keys:
                    all_keys.update(keys)

    # 输出所有的 key
    print('All Keys in Localizable.strings:')
    for key in all_keys:
        print(key)

if __name__ == "__main__":
    main()
