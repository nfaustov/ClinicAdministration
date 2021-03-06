//
//  ClinicAdministrationTests.swift
//  ClinicAdministrationTests
//
//  Created by Nikolai Faustov on 16.01.2021.
//

import XCTest
@testable import ClinicAdministration

class ClinicAdministrationTests: XCTestCase {
    func testDetectingIntersections() {
        let date = Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1))!

        let schedule1 = DoctorSchedule(
            id: UUID(uuidString: "4ac6cabf-c138-4ad5-b131-04f1bc67c197")!,
            secondName: "test1",
            firstName: "test1",
            patronymicName: "test1",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 10, minute: 00)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 12, minute: 00))!
        )
        let schedule2 = DoctorSchedule(
            id: UUID(uuidString: "3a25fc5a-1b9a-4b56-aae6-f50809802c30")!,
            secondName: "test2",
            firstName: "test2",
            patronymicName: "test2",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 11, minute: 30)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 14, minute: 30))!
        )
        let schedule3 = DoctorSchedule(
            id: UUID(uuidString: "6f57d4a5-1d2b-4293-80d8-e98653f7661e")!,
            secondName: "test3",
            firstName: "test3",
            patronymicName: "test3",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 14, minute: 00)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 16, minute: 00))!
        )
        let schedule4 = DoctorSchedule(
            id: UUID(uuidString: "bf0b4ccc-9083-4a75-a156-f48d4a8dad4e")!,
            secondName: "test4",
            firstName: "test4",
            patronymicName: "test4",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 17, minute: 00)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 18, minute: 00))!
        )
        let schedule5 = DoctorSchedule(
            id: UUID(uuidString: "4989d34f-817c-4ffe-a53c-83b72a01868a")!,
            secondName: "test5",
            firstName: "test5",
            patronymicName: "test5",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 17, minute: 30)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 18, minute: 30))!
        )

        let dataSource = TimeTableDataSource(schedules: [schedule5, schedule1, schedule2, schedule4, schedule3])
        let intersectedSchedules = dataSource.intersectedSchedules(for: date)

        XCTAssertEqual(intersectedSchedules, [schedule2, schedule5])
    }

    func testUpdateSchedule() {
        var schedule1 = DoctorSchedule(
            id: UUID(uuidString: "4ac6cabf-c138-4ad5-b131-04f1bc67c197")!,
            secondName: "test1",
            firstName: "test1",
            patronymicName: "test1",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 10, minute: 00)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 12, minute: 00))!
        )
        let schedule2 = DoctorSchedule(
            id: UUID(uuidString: "3a25fc5a-1b9a-4b56-aae6-f50809802c30")!,
            secondName: "test2",
            firstName: "test2",
            patronymicName: "test2",
            cabinet: 3,
            startingTime: Calendar.current.date(
                from: DateComponents(year: 2021, month: 1, day: 1, hour: 10, minute: 00)
            )!,
            endingTime: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 12, minute: 00))!
        )

        let dataSource = TimeTableDataSource(schedules: [schedule1, schedule2])
        schedule1.startingTime = Calendar.current.date(
            from: DateComponents(year: 2021, month: 1, day: 1, hour: 13, minute: 00)
        )!
        schedule1.endingTime = Calendar.current.date(
            from: DateComponents(year: 2021, month: 1, day: 1, hour: 17, minute: 00)
        )!

        dataSource.updateSchedule(schedule1) {
            XCTAssertNotEqual(schedule1.startingTime, schedule2.startingTime)
        }
        dataSource.updateSchedule(schedule2) {
            XCTFail("Failed. Updated unchanged shedule.")
        }
    }
}
