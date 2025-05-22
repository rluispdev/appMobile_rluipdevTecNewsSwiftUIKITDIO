//
//  NewsViewController.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 5/12/25.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK: - Propriedades
    var news: NewsModel?

    // MARK: - Componentes UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .gray
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let contentTextView = UITextView()

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = news?.source.name
        setupNavigationBarAppearance()
        setupLayout()
        setupLoadingView()
        configureView()
    }

    
    // MARK: - Configuração da Aparência da Barra de Navegação
     private func setupNavigationBarAppearance() {
         if let customPurpleColor = UIColor(named: "tecnewsPurple") {
             let appearance = UINavigationBarAppearance()
             appearance.configureWithOpaqueBackground()
             appearance.backgroundColor = customPurpleColor
             appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
             appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

             navigationController?.navigationBar.standardAppearance = appearance
             navigationController?.navigationBar.scrollEdgeAppearance = appearance
             navigationController?.navigationBar.tintColor = .white
         }
     }
    
    
    
    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [newsImageView, titleLabel, sourceLabel, dateLabel, descriptionLabel, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // News Image
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),

            // Title
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Source
            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Date
            dateLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Content
            contentTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            contentTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentTextView.heightAnchor.constraint(equalToConstant: 200),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        // Configurações visuais dos componentes
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(named: "tecnewsPurple") 

        sourceLabel.font = .systemFont(ofSize: 14)
        sourceLabel.textColor = .gray

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .darkGray

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0

        contentTextView.font = .systemFont(ofSize: 15)
        contentTextView.isEditable = false
    }

    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }

    // MARK: - Configuração dos dados
    private func configureView() {
        guard let news = news else { return }

        titleLabel.text = news.title ?? "Sem título"
        sourceLabel.text = "Fonte: \(news.source.name)"
        descriptionLabel.text = news.description

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = "Publicado em: \(formatter.string(from: news.publishedAt))"

        // Tratamento para remover "... [+XXXX chars]" se existir
        var contentText = news.content ?? ""
        if let cleanedContent = contentText.components(separatedBy: "… [+").first {
            contentText = cleanedContent.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Prioriza content se for válido, senão usa description
        contentTextView.text = contentText.isEmpty ? news.description ?? "Sem conteúdo" : contentText

        if let url = URL(string: news.urlToImage) {
            showLoading(true)
            loadImage(from: url)
        }
    }

    // MARK: - Carregamento de imagem
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.showLoading(false)
                if let data = data, let image = UIImage(data: data) {
                    self.newsImageView.image = image
                }
            }
        }.resume()
    }

    // MARK: - Controle do Loading
    private func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}
