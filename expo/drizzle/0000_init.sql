CREATE TABLE `buildings` (
	`id` text PRIMARY KEY NOT NULL,
	`createdAt` text NOT NULL,
	`updatedAt` text NOT NULL,
	`label` text NOT NULL,
	`comment` text,
	`syncState` text DEFAULT 'pending' NOT NULL,
	`lastError` text
);
--> statement-breakpoint
CREATE TABLE `entrances` (
	`id` text PRIMARY KEY NOT NULL,
	`createdAt` text NOT NULL,
	`updatedAt` text NOT NULL,
	`buildingId` text NOT NULL,
	`lat` real NOT NULL,
	`lng` real NOT NULL,
	`street` text NOT NULL,
	`number` text NOT NULL,
	`entranceName` text NOT NULL,
	`coordsConfirmed` integer NOT NULL,
	`correctedLat` real,
	`correctedLng` real,
	`addressConfirmed` integer NOT NULL,
	`stories` integer,
	`flats` integer,
	`elevators` integer,
	`yearBuilt` integer,
	`groundFloorCommercial` integer,
	`comment` text,
	`surveyStatus` text NOT NULL,
	`surveyedBy` text,
	`surveyedAt` text,
	`syncState` text DEFAULT 'pending' NOT NULL,
	`lastError` text,
	FOREIGN KEY (`buildingId`) REFERENCES `buildings`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `photos` (
	`id` text PRIMARY KEY NOT NULL,
	`createdAt` text NOT NULL,
	`updatedAt` text NOT NULL,
	`entranceId` text NOT NULL,
	`fileName` text NOT NULL,
	`remoteUrl` text,
	`takenAt` text NOT NULL,
	`lat` real,
	`lng` real,
	`heading` real,
	`uploadState` text DEFAULT 'pending' NOT NULL,
	`reviewStatus` text DEFAULT 'pending' NOT NULL,
	`reviewNote` text,
	`reviewedBy` text,
	`replacesPhotoId` text,
	`syncState` text DEFAULT 'pending' NOT NULL,
	`lastError` text,
	`localUri` text NOT NULL,
	FOREIGN KEY (`entranceId`) REFERENCES `entrances`(`id`) ON UPDATE no action ON DELETE no action
);
