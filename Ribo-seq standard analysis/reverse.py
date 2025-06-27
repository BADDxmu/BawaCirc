# 脚本名称：reverse_fastq_sequences.py
import sys

def reverse_sequence(sequence):
    """将序列反向但不互补"""
    return sequence[::-1]

def reverse_quality(quality):
    """将质量字符串反向"""
    return quality[::-1]

def process_fastq(input_file, output_file):
    """处理 FASTQ 文件"""
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        lines = infile.readlines()
        for i in range(0, len(lines), 4):
            # 读取四行
            header = lines[i].strip()
            sequence = lines[i+1].strip()
            plus = lines[i+2].strip()
            quality = lines[i+3].strip()

            # 逆序处理序列行和质量行
            reversed_sequence = reverse_sequence(sequence)
            reversed_quality = reverse_quality(quality)  # 新增质量反转

            # 写入输出文件
            outfile.write(f"{header}\n{reversed_sequence}\n{plus}\n{reversed_quality}\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("用法: python reverse_fastq_sequences.py 输入文件.fastq 输出文件.fastq")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    process_fastq(input_file, output_file)
    print(f"处理完成！结果已保存到 {output_file}")

