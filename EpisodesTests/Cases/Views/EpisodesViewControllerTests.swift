//
//  EpisodesViewControllerTests.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodesViewControllerTests: XCTestCase {
    
    var sut: EpisodesViewController!
    var mockViewModel: MockEpisodesViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockEpisodesViewModel()
        sut = EpisodesViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        mockViewModel = nil
        sut = nil
        super.tearDown()
    }
    
    func givenCellViewModels(count: Int = 4) {
        mockViewModel.cellVieModels = givenEpisodes(count: count).map { EpisodeCellViewModel($0) }
    }
    
    func givenEpisodes(count: Int = 4) -> [Episode] {
        var episodes: [Episode] = []
        for i in (1...count) {
            episodes.append(Episode(
                id: "id \(i)",
                imageUrl: "imageUrl \(i)",
                startTime: 123,
                endTime: 234,
                episodeTitle: "episodeTitle \(i)",
                title: "title \(i)"
            ))
        }
        return episodes
    }
    
    func test_init_setsViewModel() throws {
        let actualViewModel = try XCTUnwrap(sut.viewModel as? MockEpisodesViewModel)
        XCTAssertTrue(actualViewModel === mockViewModel)
    }
    
    func test_initWithCoder() {
        sut = EpisodesViewController(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    
    //MARK: ViewDidLoad lifecycle tests
    func test_viewDidLoad_createsPullToRefresh() throws {
        // when
        sut.viewDidLoad()

        // then
        let refreshControl = try XCTUnwrap(sut.tableview.refreshControl)
        let target = try XCTUnwrap(refreshControl.allTargets.first as? EpisodesViewController)
        XCTAssertTrue(sut === target)
    }
    
    func test_viewDidLoad_createsFilterButton() throws {
        // when
        sut.viewDidLoad()
        
        // then
        let filterButton = try XCTUnwrap(sut.navigationItem.rightBarButtonItem)
        let target = try XCTUnwrap(filterButton.target as? EpisodesViewController)
        XCTAssertTrue(target === sut)
    }
    
    func test_viewDidLoad_pullToRefresh_callsFetchEpisodesAction() throws {
        // when
        sut.viewDidLoad()
        
        // then
        let refreshControl = try XCTUnwrap(sut.tableview.refreshControl)
        let target = try XCTUnwrap(refreshControl.allTargets.first as? EpisodesViewController)
        let actions = refreshControl.actions(forTarget: target, forControlEvent: .valueChanged)
        let selector = try XCTUnwrap(actions?.first)
        XCTAssertEqual(actions?.count, 1)
        XCTAssertEqual(Selector(selector), #selector(EpisodesViewController.fetchEpisodes))
    }
    
    func test_viewDidLoad_sortButton_callsSortEpisodesAction() throws {
        // when
        sut.viewDidLoad()
        
        // then
        let filterButton = try XCTUnwrap(sut.navigationItem.rightBarButtonItem)
        let selector = try XCTUnwrap(filterButton.action)
        XCTAssertEqual(selector, #selector(EpisodesViewController.sortEpisodes))
    }
        
    func test_viewDidLoad_callsViewModelFetchEpisodes() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(mockViewModel.calledFetchEpisodes)
    }
    
    
    //MARK: Fetch episodes tests
    func test_fetchEpisodes_callsViewModelFetchEpisodes() {
        // when
        sut.fetchEpisodes()
        
        // then
        XCTAssertTrue(mockViewModel.calledFetchEpisodes)
    }
    
    func test_fetchEpisodes_reloadClosure_reloadsTableView() {
        // given
        class MockTableView: UITableView {
          var calledReloadData = false
          override func reloadData() {
            calledReloadData = true
          }
        }
        
        let mockTableView = MockTableView()
        sut.tableview = mockTableView
        
        // when
        mockViewModel.reloadTableClosure?()
        
        // then
        XCTAssertTrue(mockTableView.calledReloadData)
    }
    
    func test_fetchEpisodes_loadingClosure_beginsRefreshing() {
        // when
        mockViewModel.isLoading = true
        
        // then
        XCTAssertTrue(sut.tableview.refreshControl!.isRefreshing)
    }
    
    func test_fetchEpisodes_loadingClosure_endsRefreshing() {
        // when
        mockViewModel.isLoading = false
        
        // then
        XCTAssertFalse(sut.tableview.refreshControl!.isRefreshing)
    }
    
    
    //MARK: Sort episodes tests
    func test_sortEpisodes_callsViewModelSortEpisodes() {
        // when
        sut.sortEpisodes()
        
        // then
        XCTAssertTrue(mockViewModel.isSortEpisodeCalled)
    }
    
    //MARK: Tableview delegate tests
    func test_tableView_numberOfRowsInSection_returnsCellVMsCount() {
        // given
        let expected = 4
        givenCellViewModels(count: expected)
        
        // when
        let actualRowCount = sut.tableView(sut.tableview, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(actualRowCount, expected)
    }
    
    func test_tableViewCellForRowAt_givenCellViewModelSet_returnsEpisodeCells() {
        // given
        givenCellViewModels()
        
        // when
        let cells: [UITableViewCell] = (0 ..< mockViewModel.cellVieModels.count).map { i in
            let indexPath = IndexPath(row: i, section: 0)
            return sut.tableView(sut.tableview, cellForRowAt: indexPath)
        }
        
        // then
        for cell in cells {
            XCTAssertTrue(cell is EpisodeCell)
        }
    }
    
}

