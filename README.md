# Скрипт, который генерирует файлы заданного размера

На первом эапе опишем цикл, который будет проходиться по последовательности чисел от 1 до 1000 и создавать файлы. Команда `dd` позволяет нам создать файл, который будет заполнен нулями. Имя файла будет содержать префикс `slurm_`.

```bash
for i in {1..1000};do
        dd if=/dev/zero of="slurm_${i}.dat" bs=1M count=5 # /dev/zero это файл девайса, который предоставляет бесконечный поток нулевых байтов
done
```
Изменим способ задания последовательности. Будем использовать команду `seq` с флагом `-w`. Таким образом все числа в последовательности будут дополнены ведущими нулями до длины самого длинного числа. Мы получим имена файлов одинаковой длины. Например, `slurm_0001.dat` вместо `slurm_1.dat` и т.д.

```bash
for i in $(seq -w 1 1000);do
        FILENAME="slurm_${i}.dat"
        dd if=/dev/zero of="$FILENAME" bs=1M count=5 status=none
        echo "File $FILENAME created"
done
```

А что если нам нужно создать несколько групп файлов с разным префиксом и размером. Лезть в код для каждого нового случая не удобно. Поэтому сделаем так, чтобы размер и префикс можно было передавать через аргументы.

```bash
FILE_SIZE_MB=$1
PREFIX=$2

for i in $(seq -w 1 1000);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done
```

Добавим проверку, переданы ли все 2 аргумента или нет. Если нет, выведем сообщение с ошибкой.

```bash
if [[ $# -ne 2 ]]; then
	echo "Usage: $0 FILE_SIZE_MB FILE_NAME_PREFIX"
	exit 1
fi

FILE_SIZE_MB=$1
PREFIX=$2

for i in $(seq -w 1 1000);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done
```

Добавим возможность задавать количество файлов также с помощью аргументов.

```bash
if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FILE_SIZE_MB FILE_NAME_PREFIX FILE_COUNT"
	exit 1
fi

FILE_SIZE_MB=$1
PREFIX=$2
FILE_COUNT=$3

for i in $(seq -w 1 $FILE_COUNT);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done
```

Добавим сообщение с выводом об успешном созданиее заданного количества файлов с определенными размером и префиксом.

```bash
if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FILE_SIZE_MB FILE_NAME_PREFIX FILE_COUNT"
	exit 1
fi

FILE_SIZE_MB=$1
PREFIX=$2
FILE_COUNT=$3

for i in $(seq -w 1 $FILE_COUNT);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done

echo "Successfully created $FILE_COUNT files with prefix $PREFIX and size ${FILE_SIZE_MB}MB each."
```

Добавим валидацию аргументов. Проверим, в качестве размера и количества файлов нам передаются целые положительные числа или нет.

```bash
#!/bin/bash

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FILE_SIZE_MB FILE_NAME_PREFIX FILE_COUNT"
	exit 1
fi

FILE_SIZE_MB=$1
PREFIX=$2
FILE_COUNT=$3

if ! [[ $FILE_SIZE_MB =~ ^[0-9]+$ ]] || ! [[ $FILE_COUNT =~ ^[0-9]+$ ]]; then
    echo "Error: Both file size and file count must be positive integers."
    exit 1
fi

for i in $(seq -w 1 $FILE_COUNT);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done

echo "Successfully created $FILE_COUNT files with prefix $PREFIX and size ${FILE_SIZE_MB}MB each."
```