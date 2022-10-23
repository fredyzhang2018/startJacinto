#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <dirent.h>
#include <libusb.h>

#define FTDI_VENDORID (0x0403)

int main(int argc, char **argv)
{
	ssize_t len;
	libusb_device **list;
	int i;
	int r;
	int opt;
	char *search = NULL;
	int numInterfaces;
	int interfaceId;
	bool found = false;
	unsigned int bus, port, configuration, interface;
	int slen;
	char *name;
	DIR *root;
	struct dirent *e;
	unsigned int ttyn;

	while((opt = getopt(argc, argv, "t:")) != -1) {
		switch (opt) {
			case 't':
				search = optarg;
				break;
			default:
				fprintf(stderr, "unknown option\n");
				return 0;
		}
	}

	if(!search) {
		fprintf(stderr, "usage: findttyUSB -t [J7-DMSC|J7-ROOT|J7-VM|J6|J7-ETHFW]\n");
		return 0;
	}

	if(!strcmp(search, "J7-DMSC")) {
		numInterfaces = 2;
		interfaceId = 0;
	} else if(!strcmp(search, "J7-ROOT")) {
		numInterfaces = 4;
		interfaceId = 0;
	} else if(!strcmp(search, "J7-VM")) {
		numInterfaces = 4;
		interfaceId = 1;
	} else if(!strcmp(search, "J6")) {
		numInterfaces = 1;
		interfaceId = 0;
	} else if(!strcmp(search, "J7-ETHFW")) {
		numInterfaces = 4;
		interfaceId = 2;
	} else {
		fprintf(stderr, "unknown device\n");
		return 0;
	}
	
	r = libusb_init(NULL);
	if (r < 0) {
		fprintf(stderr, "libusb_init: %s\n", libusb_strerror(r));
		return 0;
	}

	len = libusb_get_device_list(NULL, &list);
	if(len < 0) {
		fprintf(stderr, "libusb_get_device_list: %s\n", libusb_strerror(len));
		libusb_exit(NULL);
		return 0;
	}

	for(i = 0; i < len; i++) {
		struct libusb_device_descriptor desc;
		libusb_device *dev;
		struct libusb_config_descriptor *conf; 

		dev = list[i];
		r = libusb_get_device_descriptor(dev, &desc);
		if (r < 0) {
			fprintf(stderr, "libusb_get_device_descriptor: %s\n", libusb_strerror(r));
			goto done;
		}

		if(desc.idVendor != FTDI_VENDORID)
			continue;

		if(desc.bNumConfigurations != 1)
			continue;

		r = libusb_get_config_descriptor(dev, 0, &conf);
		if(r < 0) {
			fprintf(stderr, "libusb_get_config_descriptor: %s\n", libusb_strerror(r));
			goto done;
		}

		if(conf->bNumInterfaces != numInterfaces) {
			libusb_free_config_descriptor(conf);
			continue;
		}

		if(conf->interface == NULL) {
			libusb_free_config_descriptor(conf);
			continue;
		}

		if(conf->interface[interfaceId].num_altsetting != 1) {
			libusb_free_config_descriptor(conf);
			continue;
		}

		if(conf->interface[interfaceId].altsetting == NULL) {
			libusb_free_config_descriptor(conf);
			continue;
		}

		bus = libusb_get_bus_number(dev);
		port = libusb_get_port_number(dev);
		configuration = conf->bConfigurationValue;
		interface = conf->interface[interfaceId].altsetting[0].bInterfaceNumber;
		found = true;

		libusb_free_config_descriptor(conf);
		break;
	}

	if(!found) {
		fprintf(stderr, "could not find device\n");
		goto done;
	}

	slen = snprintf(NULL, 0, "/sys/bus/usb/devices/%u-%u/%u-%u:%u.%u", bus, port, bus, port, configuration, interface);
	name = calloc(1, slen + 1);
	if(!name) {
		fprintf(stderr, "could not allocate name\n");
		goto done;
	}
	snprintf(name, slen + 1, "/sys/bus/usb/devices/%u-%u/%u-%u:%u.%u", bus, port, bus, port, configuration, interface);

	root = opendir(name);
	if(!root) {
		fprintf(stderr, "opendir: %s\n", strerror(errno));
		free(name);
		goto done;
	}

	while(e = readdir(root)) {
		r = sscanf(e->d_name, "ttyUSB%u", &ttyn);
		if(r != 1)
			continue;
		printf("/dev/ttyUSB%u", ttyn);
	}

	closedir(root);
	free(name);


done:
	libusb_free_device_list(list, 1);
	libusb_exit(NULL);
	return 0;
}
