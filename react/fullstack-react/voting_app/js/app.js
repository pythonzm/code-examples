class Product extends React.Component {
    constructor(props) {
        super(props);
        this.handleUpVote = this.handleUpVote.bind(this);
    }

    handleUpVote() {
        this.props.onVote(this.props.id)
    }
    render() {
        return (
        <div className='item'>
            <div className='image'>
                <img src={this.props.productImageUrl} />
            </div>
            <div className='middle aligned content'>
                <div className="header">
                    <a onClick={this.handleUpVote}>
                        <i className="large caret up icon" />
                    </a>
                    {this.props.votes}
                </div>
                <div className='description'>
                    <a href={this.props.url}>{this.props.title}</a>
                    <p>{this.props.description}</p>
                </div>
                <div className='extra'>
                    <span>Submitted by:</span>
                    <img
                    className='ui avatar image'
                    src={this.props.submitterAvatarUrl}
                    />
                </div>
            </div>
        </div>
        ); 
    }
}

class ProductList extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            products: [],
        };
        this.handleProductUpVote = this.handleProductUpVote.bind(this);
    }
    componentDidMount() {
        this.setState({products: products});
    }
    handleProductUpVote(productId) {
        // products.forEach((product) => { // product change will effect the state
        //     if (product.id === productId)
        //         product.votes = product.votes + 1;
        // });
        // this.setState({
        //     products: products
        // });

        const nextProducts = this.state.products.map((product) => {
            if (product.id === productId) {
                return Object.assign({}, product, {
                    votes: product.votes + 1,
                })
            } else {
                return product;
            }
        });
        this.setState({
            products: nextProducts
        });
    }
    render() {
        const products = this.state.products.sort((a, b) => (b.votes - a.votes));
        const productComponents = products.map((product) => (
            <Product key={'product-' + product.id} {...product} onVote={this.handleProductUpVote} />
        ));
        return (
        <div className="ui unstackable items">
           {productComponents}
        </div>
        );
    }
}

ReactDOM.render(
    <ProductList />,
    document.getElementById('content')
)